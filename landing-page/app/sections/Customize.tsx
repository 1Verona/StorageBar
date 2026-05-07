"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { SlidersHorizontal, Globe, Power } from "lucide-react";
import { StorageBarMockup } from "../components/StorageBarMockup";

const styles = ["solid", "outline", "track"] as const;
const styleLabels = ["Solid", "Outline", "Track"];

const colors = [
  { color: "#7ED321", label: "Green" },
  { color: "#FF8C42", label: "Orange" },
  { color: "#FF6B9D", label: "Pink" },
  { color: "#3498DB", label: "Blue" },
  { color: "#9B59B6", label: "Purple" },
  { color: "#1ABC9C", label: "Teal" },
];

export function Customize() {
  const [tint, setTint] = useState<string | null>(null); // null = default/system
  const [bgOpacity, setBgOpacity] = useState(20);
  const [barWidth, setBarWidth] = useState(100);
  const [styleIndex, setStyleIndex] = useState(0);

  const currentColor = tint || "#2D241F"; // Default to dark for preview
  const currentStyle = styles[styleIndex];

  return (
    <section className="slide">
      <div className="max-w-6xl w-full grid grid-cols-1 lg:grid-cols-2 gap-12 items-start px-4">
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 0.8 }}
          className="flex flex-col gap-8"
        >
          <div className="flex items-center gap-3 text-muted">
            <div className="w-10 h-10 rounded-2xl bg-accent/10 flex items-center justify-center">
              <SlidersHorizontal className="w-5 h-5 text-accent" />
            </div>
            <span className="text-sm font-bold font-mono uppercase tracking-wider">Customize</span>
          </div>

          <h2 className="text-4xl sm:text-5xl font-bold leading-tight text-foreground font-display">
            Your bar,
            <br />
            <span className="text-accent-green">your rules</span>
          </h2>

          <p className="text-muted text-lg leading-relaxed">
            Tweak every pixel. Colors, fonts, sizes, position — see changes
            instantly in Settings with a live preview.
          </p>

          <div className="flex flex-wrap gap-3">
            <div className="flex items-center gap-2 card-depth px-4 py-2 text-sm">
              <Globe className="w-4 h-4 text-accent" />
              <span>EN · ES · PT-BR</span>
            </div>
            <div className="flex items-center gap-2 card-depth px-4 py-2 text-sm">
              <Power className="w-4 h-4 text-accent-green" />
              <span>Open at login</span>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="card-depth p-8 w-full"
          data-no-drag
        >
          <div className="text-xs text-muted mb-6 font-bold font-mono uppercase tracking-wider">Live Preview</div>

          <div className="flex justify-center mb-8 py-8 rounded-2xl bg-accent/5">
            <StorageBarMockup
              progress={62}
              style={currentStyle}
              color={currentColor}
              backgroundColor={`rgba(255, 140, 66, ${bgOpacity / 100})`}
              width={barWidth * 2.2}
              height={26}
            />
          </div>

          <div className="space-y-6">
            {/* Style */}
            <div className="space-y-3">
              <label className="text-xs text-muted font-bold uppercase tracking-wider">Style</label>
              <div className="grid grid-cols-3 gap-2">
                {styleLabels.map((label, i) => (
                  <button
                    key={label}
                    onClick={() => setStyleIndex(i)}
                    className={`py-2 text-[11px] rounded-xl font-bold transition-all ${
                      styleIndex === i
                        ? "bg-accent text-white shadow-lg shadow-accent/25"
                        : "bg-accent/10 text-muted hover:bg-accent/20"
                    }`}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </div>

            {/* Color */}
            <div className="space-y-3">
              <label className="text-xs text-muted font-bold uppercase tracking-wider">Color</label>
              <div className="flex items-center gap-3">
                {/* Default color option */}
                <button
                  onClick={() => setTint(null)}
                  className={`w-10 h-10 rounded-full border-2 transition-all flex items-center justify-center ${
                    tint === null
                      ? "border-accent scale-110 shadow-lg"
                      : "border-gray-300 hover:border-gray-400"
                  }`}
                  style={{ backgroundColor: "#F5F5F5" }}
                  title="Default (system color)"
                >
                  <span className="text-[8px] font-bold text-gray-600">DF</span>
                </button>
                <div className="w-px h-8 bg-gray-200" />
                {colors.map((c) => (
                  <button
                    key={c.color}
                    onClick={() => setTint(c.color)}
                    className={`w-8 h-8 rounded-full transition-all shadow-md ${
                      tint === c.color ? "scale-125 ring-[3px] ring-white shadow-lg" : "hover:scale-110"
                    }`}
                    style={{ backgroundColor: c.color }}
                    title={c.label}
                  />
                ))}
              </div>
              <p className="text-[10px] text-muted">
                {tint === null 
                  ? "Default: follows menu bar icon color (NSColor.labelColor)" 
                  : `Selected: ${colors.find(c => c.color === tint)?.label}`}
              </p>
            </div>

            {/* Background Opacity */}
            <div className="space-y-3">
              <label className="text-xs text-muted flex justify-between font-bold uppercase tracking-wider">
                Background Opacity
                <span className="text-foreground">{bgOpacity}%</span>
              </label>
              <input
                type="range"
                min="0"
                max="40"
                value={bgOpacity}
                onChange={(e) => setBgOpacity(Number(e.target.value))}
                className="w-full h-2 bg-accent/15 rounded-full appearance-none cursor-pointer [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:w-5 [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-accent [&::-webkit-slider-thumb]:shadow-md"
              />
            </div>

            {/* Width */}
            <div className="space-y-3">
              <label className="text-xs text-muted flex justify-between font-bold uppercase tracking-wider">
                Width
                <span className="text-foreground">{barWidth}%</span>
              </label>
              <input
                type="range"
                min="30"
                max="100"
                value={barWidth}
                onChange={(e) => setBarWidth(Number(e.target.value))}
                className="w-full h-2 bg-accent/15 rounded-full appearance-none cursor-pointer [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:w-5 [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-accent [&::-webkit-slider-thumb]:shadow-md"
              />
            </div>


          </div>
        </motion.div>
      </div>
    </section>
  );
}
