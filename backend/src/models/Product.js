import { Schema, model} from 'mongoose'

const productSchema = new Schema ({
    code: String,
    name: String,
    description: String,
    imageUrl:String,
    environmentalInfo:String,
    category:String,
    environmentalCategory:String,
})

export default   model('Product', productSchema);
