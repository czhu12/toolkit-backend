import React, { useState } from "react";
import Editor from "./index"
import { Notyf } from "notyf";
import ActionBar from "./ActionBar.jsx";


function App({initialScript, saveScript}) {
  const [script, setScript] = useState(initialScript);
  const run = () => {
    saveScript(script);
    window.Toolkit.run(script.code || "");
  }
  let onSave;
  if (script.slug) {
    onSave = async () => {
      await saveScript(script);
      const notfy = new Notyf();
      notfy.success("Saved");
    }
  }

  return (
    <div className="h-full w-full">
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
  }

  return <App
    initialScript={script}
    saveScript={saveScript}
  />
}

export default EditScript;
