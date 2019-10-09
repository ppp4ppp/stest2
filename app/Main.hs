

CLIENT_JOIN&2ACK&210&1HDD_SPACE&23922742472704&1PRINT_WAITING_INFO&20&1SETUP_DICOM_INFO&2SERVER&2192.168.2.47&2105&2IPS740A&2SERVER&2192.168.2.47&2104&2IPS740A&2ES&2&2IPS740A&2SERVER&2192.168.2.47&2106&2IPS710A&2UTF-8&1SETUP_FILE_INFO&20&20&22000&20&22&20&21&22&1SETUP_FOOT_PEDAL_INFO&20&1SETUP_INPUT_INFO&22&22&20&20&1SETUP_LANGUAGE_INFO&20&1SETUP_PRINTER_INFO&20&1SETUP_SMB_SERVER_INFO&2smbuser&2&1SETUP_SYSTEM_INFO&22&1SETUP_TIME_INFO&20&20&22019-10-09&209:57&1TASK_INFO&20&230&226&22019-10-07 16:27:43&22019-10-07 16:27:43&2&2&2&2ES&2&2&20&2&22&2&2&2&2&2&2&2&2&2&2&2&2&2&1USB_INFO&1VERSION&20.9.2.6&20.97.4&1MAIN_STATE&22&200:00:00&20&1CLIENT_JOIN&2ACK&210&1HDD_SPACE&23922742472704&1PRINT_WAITING_INFO&20&1SETUP_DICOM_INFO&2SERVER&2192.168.2.47&2105&2IPS740A&2SERVER&2192.168.2.47&2104&2IPS740A&2ES&2&2IPS740A&2SERVER&2192.168.2.47&2106&2IPS710A&2UTF-8&1SETUP_FILE_INFO&20&20&22000&20&22&20&21&22&1SETUP_FOOT_PEDAL_INFO&20&1SETUP_INPUT_INFO&22&22&20&20&1SETUP_LANGUAGE_INFO&20&1SETUP_PRINTER_INFO&20&1SETUP_SMB_SERVER_INFO&2smbuser&2&1SETUP_SYSTEM_INFO&22&1SETUP_TIME_INFO&20&20&22019-10-09&209:57&1TASK_INFO&20&230&226&22019-10-07 16:27:43&22019-10-07 16:27:43&2&2&2&2ES&2&2&20&2&22&2&2&2&2&2&2&2&2&2&2&2&2&2&1USB_INFO&1VERSION&20.9.2.6&20.97.4&1MAIN_STATE&22&200:00:00&20&1
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
