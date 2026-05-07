"use client";

import { motion } from "framer-motion";

interface ProgressBarProps {
  progress: number;
}

export function ProgressBar({ progress }: ProgressBarProps) {
  const percentage = Math.round(progress * 100);

  return (
    <div className="fixed top-0 left-0 right-0 z-50 h-2 progress-track">
      <motion.div
        className="h-full rounded-full relative"
        style={{ 
          width: `${percentage}%`,
          background: "linear-gradient(90deg, #FF8C42, #FFB380)",
        }}
        transition={{ type: "spring", stiffness: 300, damping: 30 }}
      >
        <div
          className="absolute right-0 top-1/2 -translate-y-1/2 w-3 h-3 rounded-full bg-accent shadow-[0_0_12px_rgba(255,140,66,0.6)] border-2 border-white"
        />
      </motion.div>
      {percentage === 100 && (
        <motion.div
          initial={{ opacity: 0, y: -5 }}
          animate={{ opacity: 1, y: 0 }}
          className="absolute right-3 top-3 text-[10px] font-bold font-mono text-accent"
        >
          COMPLETE
        </motion.div>
      )}
    </div>
  );
}
