import React, { useEffect, useState } from 'react';
import JSConfetti from 'js-confetti'

function RunScript(script) {
  useEffect(() => {
    window.Toolkit.run(script.code);
  }, []);

  return (
    <div className="container">
      <div id="main-view">
      </div>
    </div>
  )
}

export default RunScript