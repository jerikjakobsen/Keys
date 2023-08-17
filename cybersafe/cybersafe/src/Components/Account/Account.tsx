import React from "react"
import { useState } from "react"
import AccountField from "../AccountField/AccountField"
import { Typography } from "@mui/material"
import { AccountInterface } from "../../Types/Account"

interface AccountProps {
    account: AccountInterface
}

export const Account = ({account}: AccountProps) => {

    return (
        <div className="container">
            <img src={account.imageURL?.href} style={{width: "20px", height: "20px", display: "inline-block"}}/>
            <div className="fields">
                <Typography style={{textAlign: "left", padding: "5px"}} component="h1">{account.accountName}</Typography>
                {
                    account.fields.map((field, index) => (
                        <AccountField key={index} field={field} />
                    ))
                }
            </div>
        </div>
    )
}