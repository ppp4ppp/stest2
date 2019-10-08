-- sudo docker run -d -p 8022:22 --name test_sshd rastasheep/ubuntu-sshd:14.04
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib

import Prelude hiding (span)

import qualified Data.Conduit.Network as CN
import qualified Data.Conduit.Combinators as CC
import Data.Conduit
import Control.Concurrent.Async (race_, race, concurrently)
import System.Environment
import Data.ByteString.Char8 
import Control.Monad.IO.Class

main :: IO ()
main = do
    print "test1"
    (i:(p:_)) <- getArgs
    CN.runTCPClient (CN.clientSettings (read p) (pack i) ) $ \ app -> do
        race_ 
            (CN.appSource app $$ CC.stdout)
            (CC.stdin  .| (awaitForever (yield . fst . (spanEnd (== '\n')) ) ) $$ CN.appSink app)
    where traceit i = do
                        liftIO $ print i
                        yield i

--dropn :: 