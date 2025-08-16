import { Router } from "express";
import { getKDBX } from "./GetKDBX";
import { updateKDBX } from "./UpdateKDBX";

const router = Router();

router.post("/get", getKDBX);
router.post("/update", updateKDBX);

export { router };
