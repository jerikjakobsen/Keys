import { hash, argon2d, Options } from "argon2";
import { EnvironmentManager } from "../utils/EnvironmentManager";
import { timingSafeEqual } from "crypto";

export async function argonHash(
  password: string,
  salt: string,
): Promise<string> {
  const secretBuffer = Buffer.from(EnvironmentManager.vars.HashSecret);

  const options: Options & { raw: true } = {
    raw: true,
    type: argon2d,
    memoryCost: 2 ** Number(EnvironmentManager.vars.HashPower),
    hashLength: Number(EnvironmentManager.vars.HashLength),
    timeCost: Number(EnvironmentManager.vars.HashTimeCost),
    secret: secretBuffer,
    salt: Buffer.from(salt),
  };

  const hashedPasswordBuffer: Buffer = await hash(password, options);
  const hashedPassword = hashedPasswordBuffer.toString("base64");

  return hashedPassword;
}

export async function argonHashCompare(
  unhashedPassword: string,
  salt: string,
  hashedPassword: string,
): Promise<boolean> {
  const recomputedHash = await argonHash(unhashedPassword, salt);

  const recomputedBuffer = Buffer.from(recomputedHash, "base64");
  const storedBuffer = Buffer.from(hashedPassword, "base64");

  if (recomputedBuffer.length !== storedBuffer.length) {
    return false;
  }

  return timingSafeEqual(recomputedBuffer, storedBuffer);
}

