"use client";

import { motion } from "framer-motion";

interface StorageBarMockupProps {
  progress?: number;
  style?: "solid" | "outline" | "track" | "pill" | "pill-percent" | "track-outline" | "gradient" | "minimal";
  color?: string;
  backgroundColor?: string;
  showPercent?: boolean;
  width?: number;
  height?: number;
  animated?: boolean;
  label?: string;
}

export function StorageBarMockup({
  progress = 65,
  style = "solid",
  color = "#7ED321",
  backgroundColor = "rgba(255, 140, 66, 0.12)",
  showPercent = false,
  width = 200,
  height = 24,
  animated = false,
  label,
}: StorageBarMockupProps) {
  const fillWidth = animated ? undefined : `${progress}%`;

  const renderBar = () => {
    const baseStyle = {
      width,
      height,
      borderRadius: style === "pill" || style === "pill-percent" ? height / 2 : 12,
    };

    switch (style) {
      case "solid":
        return (
          <div
            style={{ ...baseStyle, backgroundColor, boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.06)' }}
            className="relative overflow-hidden"
          >
            <motion.div
              className="absolute inset-y-0 left-0 rounded-xl"
              style={{ backgroundColor: color }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
          </div>
        );

      case "outline":
        return (
          <div
            style={{ ...baseStyle, border: `3px solid ${color}`, backgroundColor: "rgba(255,255,255,0.5)" }}
            className="relative overflow-hidden"
          >
            <motion.div
              className="absolute inset-y-0 left-0"
              style={{ backgroundColor: color }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
          </div>
        );

      case "track":
        return (
          <div
            style={{ ...baseStyle, backgroundColor, padding: 5, boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.06)' }}
            className="relative overflow-hidden"
          >
            <motion.div
              className="h-full rounded-lg"
              style={{ backgroundColor: color }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
          </div>
        );

      case "pill":
        return (
          <div
            style={{ ...baseStyle, backgroundColor, boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.06)' }}
            className="relative overflow-hidden"
          >
            <motion.div
              className="absolute inset-y-0 left-0 rounded-full"
              style={{ backgroundColor: color }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
          </div>
        );

      case "pill-percent":
        return (
          <div
            style={{ ...baseStyle, backgroundColor, display: "flex", alignItems: "center", padding: "0 14px", boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.06)' }}
            className="relative overflow-hidden"
          >
            <motion.div
              className="absolute inset-y-0 left-0 rounded-full"
              style={{ backgroundColor: color }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
            <span className="relative z-10 text-xs font-bold text-white mix-blend-difference">
              {progress}%
            </span>
          </div>
        );

      case "track-outline":
        return (
          <div
            style={{ ...baseStyle, border: `3px solid rgba(255,140,66,0.25)`, padding: 4, backgroundColor: "rgba(255,255,255,0.5)" }}
            className="relative overflow-hidden"
          >
            <motion.div
              className="h-full rounded-lg"
              style={{ backgroundColor: color }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
          </div>
        );

      case "gradient":
        return (
          <div
            style={{ ...baseStyle, backgroundColor, boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.06)' }}
            className="relative overflow-hidden"
          >
            <motion.div
              className="absolute inset-y-0 left-0 rounded-xl"
              style={{
                background: `linear-gradient(90deg, ${color}, #FF8C42)`,
              }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
          </div>
        );

      case "minimal":
        return (
          <div
            style={{ ...baseStyle, backgroundColor: "transparent" }}
            className="relative"
          >
            <div className="absolute inset-x-0 top-1/2 -translate-y-1/2 h-[3px] bg-accent/15 rounded-full" />
            <motion.div
              className="absolute left-0 top-1/2 -translate-y-1/2 h-[3px] rounded-full"
              style={{ backgroundColor: color }}
              initial={animated ? { width: 0 } : undefined}
              animate={{ width: fillWidth ?? `${progress}%` }}
              transition={{ duration: 1, ease: "easeOut" }}
            />
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className="flex flex-col items-center gap-2">
      {renderBar()}
      {showPercent && style !== "pill-percent" && (
        <span className="text-xs text-muted font-mono font-semibold">{progress}%</span>
      )}
      {label && <span className="text-[10px] uppercase tracking-wider text-muted font-semibold">{label}</span>}
    </div>
  );
}
