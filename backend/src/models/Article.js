import { Schema, model} from 'mongoose'

const articleSchema = new Schema ({
    title: String,
    description: String,
    category: String,
    articleUrl: String,
    content: String,
    timestamp: Date
})

export default   model('Article', articleSchema);