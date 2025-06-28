import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { ClerkProvider } from "@clerk/clerk-react";
import { shadesOfPurple } from "@clerk/themes";

// Import your publishable key
const PUBLISHABLE_KEY = import.meta.env.VITE_CLERK_PUBLISHABLE_KEY;

// If no Clerk key is provided, render a simple fallback
if (!PUBLISHABLE_KEY) {
  ReactDOM.createRoot(document.getElementById("root")).render(
    <React.StrictMode>
      <div style={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        height: '100vh',
        fontFamily: 'Arial, sans-serif',
        backgroundColor: '#1a1a1a',
        color: 'white'
      }}>
        <div style={{ textAlign: 'center' }}>
          <h1>Hirrd - Job Portal</h1>
          <p>Please set up your VITE_CLERK_PUBLISHABLE_KEY environment variable</p>
          <p>Create a .env file in the root directory with:</p>
          <code style={{ 
            backgroundColor: '#333', 
            padding: '10px', 
            borderRadius: '5px',
            display: 'block',
            margin: '10px 0'
          }}>
            VITE_CLERK_PUBLISHABLE_KEY=your_clerk_key_here
          </code>
        </div>
      </div>
    </React.StrictMode>
  );
} else {
  ReactDOM.createRoot(document.getElementById("root")).render(
    <React.StrictMode>
      <ClerkProvider
        appearance={{
          baseTheme: shadesOfPurple,
        }}
        publishableKey={PUBLISHABLE_KEY}
        afterSignOutUrl="/"
      >
        <App />
      </ClerkProvider>
    </React.StrictMode>
  );
}
