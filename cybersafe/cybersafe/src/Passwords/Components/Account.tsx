import React from "react"
import { useState } from "react"
import AccountField from "./AccountField"
import { Typography } from "@mui/material"


export interface Field {
    name: string,
    value: string,
    type: string
}

export interface AccountInterface {
    accountName: string,
    imageURL?: URL,
    fields: Field[]
}

export interface AccountProps {
    account: AccountInterface
}

export const Account: React.FC<AccountProps> = ({account}) => {

    return (
        <div className="container">
            <img src={account.imageURL?.href} style={{width: "20px", height: "20px", display: "inline-block"}}/>
            <div className="fields">
                <Typography style={{textAlign: "left", padding: "5px"}} component="h1">{account.accountName}</Typography>
                {
                    account.fields.map((field, index) => (
                        <AccountField key={index} fieldType={field.name} fieldValue={field.value} type={field.type} />
                    ))
                }
            </div>
        </div>
    )
}