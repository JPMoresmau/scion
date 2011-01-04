{-# OPTIONS_GHC -fno-warn-duplicate-exports #-}
{-# LANGUAGE CPP #-}
-- | Compatibility across several GHC versions.
--
-- Anything that requires @ifdef@s on the GHC version should go here.
module Scion.Ghc
  ( module Scion.Ghc,
    module GHC,
    module Name,
    module Outputable,
  )
where

import GHC
import Name
import Outputable

-- | Extract the renamed source's @HsGroup@ information, which contains its declaration
-- information. Note that @RenamedSource@ structure differs between versions of GHC. 
renamedSourceGroup :: RenamedSource -> HsGroup Name

isUserDefinedId :: Id -> Bool
isRecStmt :: StmtLR idL idR -> Bool

#if GHC_VERSION < 611

renamedSourceGroup (grp, _, _, _, _) = grp

isUserDefinedId _ident = True

isRecStmt (RecStmt _ _ _ _ _) = True
isRecStmt _ = False

recS_stmts :: StmtLR idL idR -> [LStmtLR idL idR]
recS_stmts (RecStmt ss _ _ _ _) = ss
recS_stmts _ = undefined                     -- FIXME: What should this be?

#else

renamedSourceGroup (grp, _, _, _) = grp
isUserDefinedId _ident = True

isRecStmt (RecStmt _ _ _ _ _ _ _ _) = True
isRecStmt _ = False

#endif
