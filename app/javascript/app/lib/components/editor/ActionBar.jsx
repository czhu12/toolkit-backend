import * as React from 'react'                          

function ActionBar({onRun, onSave, viewApp, onEdit}) {
  return (
    <div className="action-bar">
      <div className="flex flex-row justify-between">
        <div className="flex-initial">
          {onSave && (
            <button className="btn btn-primary btn-outline	btn-sm mr-3" onClick={onSave}>
              <span>Save</span>
              <span className="icon is-small">
                <i className="fa-solid fa-floppy-disk"></i>
              </span>
            </button>
          )}
          {onEdit && (
            <button className="btn btn-primary btn-outline	btn-sm mr-3" onClick={onEdit}>
              <span>Edit</span>
              <span className="icon is-small">
                <i className="fa-solid fa-pen"></i>
              </span>
            </button>
          )}
          {viewApp && (
            <a className="btn btn-primary btn-outline	btn-sm" href={viewApp}>
              <span>View App</span>
              <span className="icon is-small">
                <i className="fa-solid fa-link"></i>
              </span>
            </a>
          )}
        </div>
        <div className="flex-initial">
          {onRun && (
            <button onClick={onRun} className="btn btn-primary btn-sm is-primary">
              <span>Run</span>
              <span className="icon is-small">
                <i className="fa-solid fa-play"></i>
              </span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

export default ActionBar;