import React, { useState, ChangeEvent, FormEvent } from 'react';
import Typography from '@mui/material/Typography';
import './AccountField.css'
import {Field} from "../../Types/Account"

const convertToDots = (text: string) => {
    return text.replace(/./g, '•');
  };

interface AccountFieldProps {
    field: Field
}

const AccountField = ({field}: AccountFieldProps) => {
    return (
    <div style={{padding: '5px'}}>
        <div className="wrapper">
                <Typography  component="p">
                    <strong>{field.type}</strong>
                </Typography>
            <Typography component="p">
                {field.type === "password" ? convertToDots(field.value) : field.value}
            </Typography>
    </div>
  </div>
  )
}

export default AccountField