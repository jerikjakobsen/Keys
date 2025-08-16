import { Request, Response, NextFunction } from "express";
import { EnvironmentManager } from "../utils/EnvironmentManager";

export function validateServerKey(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  const keyHeader = req.headers["x-server-key"];
  const key = Array.isArray(keyHeader) ? keyHeader[0] : keyHeader;
  console.log(req.headers);
  if (!key || EnvironmentManager.vars.ServerKey !== key) {
    return res.status(401).json({ message: "Request not authenticated" });
  }

  return next();
}
