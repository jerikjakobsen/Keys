import { Router } from "express";
import { createAccount } from "./CreateAccount";
import { login } from "./Login";

const router = Router();

router.post("/login", login);
router.post("/createAccount", createAccount);

export { router };
