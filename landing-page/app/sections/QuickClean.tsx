"use client";

import { motion } from "framer-motion";
import { Trash2, FileX, ImageIcon, HardDrive, Code, Globe, Smartphone, FileArchive, Download, Sparkles } from "lucide-react";
import { StorageBarMockup } from "../components/StorageBarMockup";

const items = [
  { icon: Trash2, label: "Trash", color: "#EF4444", bgColor: "#FEE2E2" },
  { icon: FileX, label: "Caches", color: "#F59E0B", bgColor: "#FEF3C7" },
  { icon: Download, label: "Downloads", color: "#8B5CF6", bgColor: "#EDE9FE" },
  { icon: ImageIcon, label: "Screenshots", color: "#10B981", bgColor: "#D1FAE5" },
  { icon: HardDrive, label: "Logs", color: "#3B82F6", bgColor: "#DBEAFE" },
  { icon: Code, label: "Xcode Data", color: "#F59E0B", bgColor: "#FEF3C7" },
  { icon: Globe, label: "Browser Caches", color: "#EC4899", bgColor: "#FCE7F3" },
  { icon: Smartphone, label: "iOS Backups", color: "#06B6D4", bgColor: "#CFFAFE" },
  { icon: FileArchive, label: "DMG Files", color: "#F97316", bgColor: "#FFEDD5" },
];

export function QuickClean() {
  return (
    <section className="slide">
      <div className="max-w-5xl w-full flex flex-col items-center gap-12 px-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 0.8 }}
          className="text-center"
        >
          <div className="flex items-center justify-center gap-3 text-muted mb-5">
            <div className="w-10 h-10 rounded-2xl bg-accent-green/15 flex items-center justify-center">
              <Sparkles className="w-5 h-5 text-accent-green" />
            </div>
            <span className="text-sm font-bold font-mono uppercase tracking-wider">Quick Clean</span>
          </div>
          <h2 className="text-4xl sm:text-5xl font-bold mb-4 text-foreground font-display">
            One click, GBs back
          </h2>
          <p className="text-muted text-lg max-w-md mx-auto leading-relaxed">
            Clean trash, caches, old downloads, Xcode derived data, and more —
            all in a single click.
          </p>
        </motion.div>

        <div className="grid grid-cols-3 gap-5 w-full max-w-2xl">
          {items.map((item, i) => (
            <motion.div
              key={item.label}
              initial={{ opacity: 0, scale: 0.8 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true, amount: 0.3 }}
              transition={{ duration: 0.4, delay: i * 0.08 }}
              className="card-depth p-5 flex flex-col items-center gap-3 group hover:scale-[1.05] transition-transform"
            >
              <div
                className="w-12 h-12 rounded-2xl flex items-center justify-center transition-transform group-hover:scale-110"
                style={{ backgroundColor: item.bgColor }}
              >
                <item.icon className="w-6 h-6" style={{ color: item.color }} />
              </div>
              <span className="text-xs text-muted font-bold">{item.label}</span>
              <motion.div
                initial={{ scale: 0 }}
                whileInView={{ scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: 0.5 + i * 0.1, type: "spring" }}
              >
                <div className="w-5 h-5 rounded-full bg-accent-green flex items-center justify-center shadow-md shadow-accent-green/30">
                  <svg className="w-3 h-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={4}>
                    <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                  </svg>
                </div>
              </motion.div>
            </motion.div>
          ))}
        </div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.8 }}
          className="card-depth p-8 w-full max-w-md"
        >
          <div className="flex items-center justify-between mb-4">
            <span className="text-xs text-muted font-bold font-mono uppercase tracking-wider">Space Recovered</span>
            <span className="text-sm font-bold text-accent-green">+12.4 GB</span>
          </div>
          <StorageBarMockup
            progress={0}
            style="solid"
            color="#7ED321"
            width={300}
            height={18}
            animated
          />
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ delay: 1.2 }}
            className="mt-3 text-[11px] text-muted text-center font-medium"
          >
            Before: 89% full → After: 74% full
          </motion.div>
        </motion.div>
      </div>
    </section>
  );
}
