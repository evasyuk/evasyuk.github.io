import React from "react";
import { render } from "react-dom";
import { createGlobalStyle } from "styled-components";

const target = document.querySelector("#app")
const GlobalStyles = createGlobalStyle`
  #root{height: 100vh}
`

render(
    <div>Land here</div>,
    target
)
