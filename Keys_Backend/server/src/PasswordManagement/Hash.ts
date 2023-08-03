import { hash, argon2d, Options} from 'argon2'
import dotenv from 'dotenv'
dotenv.config()

export async function argonHash(password: string, salt: string): Promise<string> {

    let secretBuffer = Buffer.from(process.env.HASH_SECRET!)

    let options: Options & { raw: true; }  = {
        raw: true,
        type: argon2d,
        memoryCost: 2 ** Number(process.env.HASH_POWER!),
        hashLength: Number(process.env.HASH_LENGTH!),
        timeCost: Number(process.env.HASH_TIME_COST!),
        secret: secretBuffer,
        salt: Buffer.from(salt)
    }
    console.log(options)

    let hashedPasswordBuffer: Buffer = await hash(password, options)
    let hashedPassword = hashedPasswordBuffer.toString('base64')

    return hashedPassword
}