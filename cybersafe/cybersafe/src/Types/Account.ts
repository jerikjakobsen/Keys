export interface AccountInterface {
    accountName: string,
    imageURL?: URL,
    fields: Field[],
    id: string
}

export interface Field {
    name: string,
    value: string,
    type: string
}