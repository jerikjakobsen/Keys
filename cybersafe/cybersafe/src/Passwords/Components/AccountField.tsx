import React, { useState, ChangeEvent, FormEvent } from 'react';
import Typography from '@mui/material/Typography';
import './AccountField.css'

interface AccountFieldProp {
    fieldType: string,
    fieldValue: string,
    type: string
}

const convertToDots = (text: string) => {
    return text.replace(/./g, '•');
  };

const AccountField: React.FC<AccountFieldProp> = ({fieldType, fieldValue, type}) => {
    return (
    <div style={{padding: '5px'}}>
        <div className="wrapper">
                <Typography  component="p">
                    <strong>{fieldType}</strong>
                </Typography>
            <Typography component="p">
                {type === "password" ? convertToDots(fieldValue) : fieldValue}
            </Typography>
    </div>
  </div>
  )
}

export default AccountField