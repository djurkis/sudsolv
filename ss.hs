import Data.List hiding (find)
import Data.Array
import Control.Monad
import Data.Maybe
import System.Environment



type Square = (Char,Char)
-- index of an element in battleship style, Eg. A1 is top left
type Digit = Char
-- elements to be used in the grid

rows = ['A'..'I']
columns = ['1'..'9']
digits = columns

leftupper = ('A','1')
rightbottom= ('I','9')

bound = (leftupper,rightbottom)

type Unit = [Square]
--grid is 2D array of chars
type Grid = Array Square [Digit]
rbox =  chunky 3 rows
cbox =  chunky 3 columns


-- chunky :: [a] -> [[a]]
chunky n [] = []
chunky n l = h: chunky n rest
             where (h,rest) = splitAt n l


squares = cproduct rows columns


cproduct :: [Char] -> [Char] -> [(Char,Char)]
cproduct x y  = [(a,b) | a <- x, b <- y]

-- list of all related segments
segL :: [Unit]
segL = columnar++ rowy ++ boxes
      where columnar = [cproduct rows [c]|c<-columns]
            rowy     = [cproduct [r] columns| r<-rows]
            boxes    = [cproduct rs cs | rs <-rbox,cs <-cbox]




--square -> Unit array
segs :: Array Square [Unit]
segs = array bound umap
      where umap = [ ((x,y), [ delete (x,y) s | s <- segL,(x,y) `elem` s] )  | (x,y) <- squares]

peers :: Array Square [Square]
peers = array bound[(s, (nub.concat)(segs!s)) | s <- squares ]







-- all possible options for given square
newGrid :: Grid
newGrid = array bound [(sq,digits) |sq<-squares]


--try to assign a value to a square in a grid
assign :: Grid -> (Square,Digit) -> Maybe Grid
assign g (s,v) = if notElem v digits then return g
                                     else do
                                       --- check possible options and delete
                                       let opts = g ! s
                                           new = delete v opts
                                           toprop = (zip (cycle [s] ) new )
                                       foldM propagate g toprop



--
find :: Char-> Grid -> [(Char,Char)] -> Maybe Grid
find d g u = let res = filter ((elem d).(g!)) u
               in case res of
                 --contradiction
                 [] -> Nothing
                 -- assign
                 [x]-> assign g (x,d)
                 _  -> return g



-- propagates an update through  a Grid
propagate :: Grid -> (Square,Digit) -> Maybe Grid
propagate g (position,d) = let opts = g ! position
                         --nothing to do
                      in if notElem d opts then return g

                        --deletes d from options for a square
                        -- and updates the grid
                          else do let opts' = delete d opts
                                      g' = g // [(position,opts')]

                                  g'' <- case opts' of
                                    []      -> Nothing -- unsolvable
                                    [x]     -> do let peers' = peers ! position --square is determined and propagate
                                                  let toprop = zip peers' (cycle [x])
                                                  foldM propagate g' toprop
                                    _       -> return g'
                                  -- assign
                                  foldM (find d) g'' (segs ! position)




search :: Grid -> Maybe Grid
search g = case [(length peers,(s,peers)) | (s,peers) <- assocs g, (length peers) /= 1] of
                    --solved without guessing
                    [] -> return g

                    x  -> do let (_,(pos,opts)) = minimum x
                             --try the minimum remaining values heuristic
                             msum [assign g (pos,val) >>= search | val <- opts]


str2grid :: String -> Maybe Grid
str2grid s = foldM assign newGrid (zip squares s)


solve :: String -> Maybe Grid
solve str = do
  grid <- str2grid str
  search grid



grid2strs :: Maybe Grid ->[ String]
grid2strs Nothing = []
grid2strs (Just g) = let str = concat $ elems g
                     in chunky 9 str


printgrid :: Maybe Grid -> Int -> IO ()
printgrid Nothing i = do putStrLn $ "Grid " ++ show i ++ " is Unsolvable..."
printgrid g i= let x = concat $ intersperse ['\n'] $ grid2strs g
              in
              do putStrLn $ "Grid "++ show i
                 putStrLn x


--lines every9nth char
by9 :: [String] ->[String]
by9 [] = []
by9 l = (concat h):by9 rest
        where (h,rest) = splitAt 9 l


run :: String -> IO ()
run x = do
   contents <- readFile x
   let ss = lines contents
       fs = by9 $ filter ('G' `notElem`) ss
       solved = map solve fs
       gridnums = zip solved [1..]
   mapM_ (\(x,y) -> printgrid x y) gridnums



run_main :: [String] -> IO ()
run_main x = case x of
             ["-f",path] -> run path
             _ -> putStrLn "Usage: sud -f path"



main = do
  args <- getArgs
  run_main args
