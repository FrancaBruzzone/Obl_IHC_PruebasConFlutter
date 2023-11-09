import app from './app.js';
import  connect from './database.js'

async function main() {
    await connect();
    await app.listen(4000)
    console.log('Server on port 4000: Connected')
}

main();