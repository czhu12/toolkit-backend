import React, { useState } from "react";
import Editor from "./index"
import { Notyf } from "notyf";
import ActionBar from "./ActionBar.jsx";
import { useWindowSize } from "@uidotdev/usehooks";
import { put } from '@rails/request.js'



function App({initialScript, saveScript}) {
  const [script, setScript] = useState(initialScript);
  const run = () => {
    window.Toolkit.run(script.code || "");
  }
  let onSave;
  if (script.slug) {
    onSave = async () => {
      await saveScript(script);
    }
  }

  const query = useWindowSize();
  const editorHeight = query.height - document.getElementsByTagName('header')[0].offsetHeight;
  return (
    <div className="w-full" style={{height: `${editorHeight}px`}}>
      <div className="flex flex-row m-0 h-full">
        <div className="flex-1 flex flex-col">
          <Editor
            className="flex-1"
            code={script.code}
            setCode={(code) => setScript({...script, code})}
          />
          <div className="mx-3 flex-initial">
            <ActionBar
              onRun={run}
              viewApp={script.slug && `/s/${script.slug}`}
              onSave={onSave}
            />
          </div>
        </div>
        <div className="flex-1">
          <div id="main-view"></div>
        </div>
      </div>
    </div>
  )
}

function EditScript({script}) {
  const saveScript = async (script) => {
    const notyf = new Notyf();
    const response = await put(`/scripts/${script.id}`, {
      body: { script },
      contentType: "application/json",
      headers: {},
      query: {},
      responseKind: "json"
    })
    if (response.ok) {
      notyf.success("Saved");
    } else {
      notyf.error("Something went wrong saving your script");
    }
  }

  return <App
    initialScript={script}
    saveScript={saveScript}
  />
}

export default EditScript;
