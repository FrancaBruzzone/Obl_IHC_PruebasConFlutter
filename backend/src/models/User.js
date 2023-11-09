import { Schema, model} from 'mongoose'

const userSchema = new Schema ({
    uuid: String,
    name: String,
    mail: String,
    avatar: String,
})

export default   model('User', userSchema);