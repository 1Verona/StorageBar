"use client";

import Image from "next/image";
import { motion } from "framer-motion";
import { Download, ExternalLink } from "lucide-react";
import { useDownload } from "../hooks/useDownload";

interface BottomBarProps {
  progress: number;
}

export function BottomBar({ progress }: BottomBarProps) {
  const isFull = progress >= 0.95;
  const { isDownloading, downloadLatest } = useDownload();

  return (
    <div 
      className="fixed bottom-0 left-0 right-0 z-50 glass border-t border-white/60" 
      style={{ borderRadius: '24px 24px 0 0' }}
    >
      <div className="flex items-center justify-between px-6 py-4 sm:px-10 max-w-7xl mx-auto">
        <div className="flex items-center gap-4">
          <div className="p-1.5 rounded-2xl bg-white shadow-[0_2px_12px_rgba(255,140,66,0.15)]">
            <Image
              src="/icon.png"
              alt="StorageBar"
              width={40}
              height={40}
              className="rounded-xl"
            />
          </div>
          <div className="hidden sm:block">
            <div className="text-sm font-bold text-foreground">StorageBar</div>
            <div className="text-xs text-muted">macOS menubar app</div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          {/* Download Button */}
          <motion.button
            onClick={downloadLatest}
            disabled={isDownloading}
            data-no-drag
            className="inline-flex items-center gap-2 px-4 py-2.5 rounded-full text-sm font-bold transition-all shadow-md bg-white text-foreground hover:bg-white/90 border border-black/5 disabled:opacity-60"
            whileTap={{ scale: 0.95 }}
          >
            {isDownloading ? (
              <div className="w-4 h-4 border-2 border-accent/30 border-t-accent rounded-full animate-spin" />
            ) : (
              <Download className="w-4 h-4 text-accent" />
            )}
            <span className="hidden sm:inline">Download</span>
          </motion.button>

          {/* Buy License Button */}
          <motion.a
            href="https://veronajoe.gumroad.com/l/StorageBar"
            target="_blank"
            rel="noopener noreferrer"
            data-no-drag
            className={`inline-flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-bold transition-all shadow-lg ${
              isFull
                ? "bg-accent text-white animate-pulse-cta shadow-[0_4px_24px_rgba(255,140,66,0.4)]"
                : "bg-foreground text-white hover:bg-foreground/90 shadow-[0_4px_16px_rgba(45,36,31,0.15)]"
            }`}
            whileTap={{ scale: 0.95 }}
          >
            <span className="hidden sm:inline">Buy License</span>
            <span className="sm:hidden">$2</span>
            <ExternalLink className="w-3.5 h-3.5" />
          </motion.a>
        </div>
      </div>
    </div>
  );
}
