// to be ran in node
const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");

function generateHTML(dirName, files, path) {
    return `<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${dirName}</title>
        <style>
        html {
            height:100%;
        }
        body {
            display: flex;
            align-items: center;
            height:100%;
            flex-direction: column;
        }
        a, p {
            display: block;
            font-size: 1.2rem;
            margin: 0.2rem 0;
        }
        h1 {
            font-family: sans-serif;
        }
        </style>
    </head>
    <body>
        <h1>Helpful WebAssembly</h1>
        <p>${path}</p>
        ${files.filter(file=>file.isDirectory()).filter(file=>!file.name.startsWith(".")).reduce((acc, cur)=>acc + `<a href="${cur.name}">${cur.name}</a>`, "") || "<p>No files in this directory.</p>"}
    </body>
    </html>`;
}

function buildDirectory(directoryName, pathToParent) {
    const pathToDir = path.normalize(pathToParent+directoryName+"/");
    if(directoryName.startsWith(".")) {
        return false; // don't run the rest, it is hidden
    }
    fs.readdir(pathToDir, {withFileTypes: true}, (err, files)=>{
        if(err) {
            throw err;
        }
        // if no wat files, generate a directory viewer
        if(shouldGenerateHTML && !files.some((file)=>path.extname(file.name) === ".wat")) {
            fs.writeFile(path.normalize(pathToDir+"index.html"), generateHTML(directoryName, files, pathToDir), ()=>{}); // we don't need to use the callback
        }

        files.forEach((file)=>{
            if (file.isDirectory()) {
                // recursively build
                buildDirectory(file.name, pathToDir);
            } else {
                // if the extension is wat
                if (path.extname(file.name) === ".wat") {
                    console.log("converting file "+file.name);
                    exec(`wat2wasm ${path.normalize(pathToDir + file.name)} -o ${pathToDir + file.name.replace(".wat", ".wasm")}`, (e) => {
                        if (e) {
                            throw e;
                        }
                    });
                }
            }
        });
    });
}

const shouldGenerateHTML = process.argv.slice(2).includes("--generate-html");
buildDirectory(path.basename(path.normalize(__dirname+"/../")), path.normalize("../"));