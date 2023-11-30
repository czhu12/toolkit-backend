import React, { useState } from "react";
import Editor from "./index"
import { Notyf } from "notyf";
import ActionBar from "./ActionBar.jsx";
import { useWindowSize } from "@uidotdev/usehooks";
import { put } from '@rails/request.js'



function EditScript({initialScript, heightSetting="detect"}) {
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
  const style = heightSetting === "detect" ? {height: `${editorHeight}px`} : {};
  return (
    <div className={`w-full ${heightSetting === "inherit" ? "h-full" : ""}`} style={style}>
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

export default EditScript;
