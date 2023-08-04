import {Request, Response} from "express"
import { GetObjectCommand, S3Client} from "@aws-sdk/client-s3"
import { Readable } from 'stream'


export default async function getKDBX(req: Request, res: Response) {
    const {userID, isAuthenticated} = req.session

    if (!userID || !isAuthenticated) {
        return res.status(400).json({"message": "User not authenticated"})
    }
    try {
        const s3Client = new S3Client({region: process.env.AWS_REGION})
        const command = new GetObjectCommand({
            Bucket: process.env.AWS_BUCKET,
            Key: userID
        })
        let fileObject = await s3Client.send(command)
        let fileStream = fileObject.Body as Readable
        res.appendHeader('content-type', 'application/octet-stream')
        res.appendHeader('content-disposition', `attachment;filename='${userID}'`)

        fileStream.pipe(res)

        fileStream.once('end', () => {
            return res.status(200)
        })

        return res.status(200)
    } catch (err) {
        console.log(err)
        return res.status(500).json({"message": "Something went wrong on our end!"})
    }

}