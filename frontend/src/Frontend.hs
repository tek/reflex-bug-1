{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE BlockArguments #-}

module Frontend where

import Common.Route
import Control.Monad
import Control.Monad.Fix (MonadFix)
import Obelisk.Frontend
import Obelisk.Generated.Static
import Obelisk.Route
import Obelisk.Route.Frontend (RoutedT)
import Reflex.Dom.Core

bug ::
  MonadFix m =>
  PostBuild t m =>
  MonadHold t m =>
  DomBuilder t m =>
  RoutedT t route m ()
bug = do
  dynText (pure "zero")
  void $ simpleList (pure ["one"]) (dyn_ . fmap text)
  void $ listWithKey (pure (() =: "two")) (const (el "p" . dynText))

frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = do
      el "title" $ text "Obelisk Minimal Example"
      elAttr "link" ("href" =: static @"main.css" <> "type" =: "text/css" <> "rel" =: "stylesheet") blank
  , _frontend_body = do
      el "h1" $ text "Welcome to Obelisk!"
      bug
  }
