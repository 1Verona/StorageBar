"use client";

import { motion } from "framer-motion";
import { Shield, Globe, Cloud, Zap, Lock, Feather } from "lucide-react";

const specs = [
  {
    icon: Shield,
    title: "Developer ID Signed",
    desc: "Gatekeeper friendly, notarized by Apple",
  },
  {
    icon: Cloud,
    title: "Auto-updates",
    desc: "Seamless updates via Sparkle — no DMG drag-and-drop",
  },
  {
    icon: Globe,
    title: "3 Languages",
    desc: "English, Español, Português (BR)",
  },
  {
    icon: Lock,
    title: "Secure Licensing",
    desc: "Gumroad integration with offline master key fallback",
  },
  {
    icon: Zap,
    title: "Lightweight",
    desc: "~1700 lines of pure Swift, zero dependencies",
  },
  {
    icon: Feather,
    title: "Open at Login",
    desc: "Enabled by default via SMAppService",
  },
];

export function TechSpecs() {
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
            <div className="w-10 h-10 rounded-2xl bg-accent/10 flex items-center justify-center">
              <Shield className="w-5 h-5 text-accent" />
            </div>
            <span className="text-sm font-bold font-mono uppercase tracking-wider">Built Right</span>
          </div>
          <h2 className="text-4xl sm:text-5xl font-bold mb-4 text-foreground font-display">
            Lightweight. Signed. Secure.
          </h2>
          <p className="text-muted text-lg max-w-md mx-auto leading-relaxed">
            Built with SwiftUI, AppKit, and Sparkle. No bloat, no telemetry.
          </p>
        </motion.div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5 w-full max-w-4xl">
          {specs.map((spec, i) => (
            <motion.div
              key={spec.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, amount: 0.3 }}
              transition={{ duration: 0.5, delay: i * 0.1 }}
              className="card-depth p-6 flex items-start gap-4 hover:scale-[1.02] transition-transform"
            >
              <div className="w-11 h-11 rounded-2xl bg-accent/10 flex items-center justify-center flex-shrink-0 shadow-sm">
                <spec.icon className="w-5 h-5 text-accent" />
              </div>
              <div>
                <h3 className="text-sm font-bold mb-1 text-foreground">{spec.title}</h3>
                <p className="text-xs text-muted leading-relaxed">{spec.desc}</p>
              </div>
            </motion.div>
          ))}
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ delay: 0.8 }}
          className="flex flex-wrap items-center justify-center gap-3 text-xs text-muted font-bold font-mono"
        >
          {["SwiftUI", "AppKit", "Sparkle", "ServiceManagement", "macOS 14+"].map((tag) => (
            <span key={tag} className="card-depth px-4 py-2 text-[11px]">{tag}</span>
          ))}
        </motion.div>
      </div>
    </section>
  );
}
