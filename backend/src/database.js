import mongoose from 'mongoose';

async function connect() {
    await mongoose.connect('mongodb://10.30.1.88:27017/ihc', {
        useNewUrlParser:true
    });
    console.log('Database: Connected');
};

export default  connect
