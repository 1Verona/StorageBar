"use client";

import { motion } from "framer-motion";
import { Settings, ArrowRight, Check } from "lucide-react";
import { StorageBarMockup } from "../components/StorageBarMockup";

export function Problem() {
  return (
    <section className="slide">
      <div className="max-w-5xl w-full grid grid-cols-1 md:grid-cols-2 gap-16 items-center px-4">
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 0.8 }}
          className="flex flex-col gap-8"
        >
          <div className="flex items-center gap-3 text-muted">
            <div className="w-10 h-10 rounded-2xl bg-accent/10 flex items-center justify-center">
              <Settings className="w-5 h-5 text-accent" />
            </div>
            <span className="text-sm font-bold font-mono uppercase tracking-wider">The Problem</span>
          </div>

          <h2 className="text-4xl sm:text-5xl font-bold leading-tight text-foreground font-display">
            &quot;About This Mac...&quot;
            <br />
            <span className="text-muted">again?</span>
          </h2>

          <p className="text-muted text-lg leading-relaxed">
            Stop digging through System Settings just to check your disk space.
            StorageBar puts a beautiful, live progress bar right where you need it —
            in your menubar.
          </p>

          <ul className="space-y-4">
            {[
              "No more opening About This Mac",
              "No more guessing how full your disk is",
              "Always visible, always updated",
            ].map((item, i) => (
              <motion.li
                key={item}
                initial={{ opacity: 0, x: -20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.3 + i * 0.15 }}
                className="flex items-center gap-4 text-sm font-medium"
              >
                <div className="w-6 h-6 rounded-full bg-accent-green/20 flex items-center justify-center flex-shrink-0">
                  <Check className="w-3.5 h-3.5 text-accent-green" />
                </div>
                {item}
              </motion.li>
            ))}
          </ul>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="flex flex-col items-center gap-8"
        >
          {/* Before */}
          <div className="card-depth p-8 w-full max-w-sm">
            <div className="text-xs text-muted mb-4 font-bold font-mono uppercase tracking-wider">Before</div>
            <div className="flex items-center gap-3 text-muted p-4 rounded-2xl bg-accent/5">
              <Settings className="w-5 h-5 text-accent flex-shrink-0" />
              <span className="text-sm font-medium">System Settings → General → About</span>
            </div>
          </div>

          <div className="w-10 h-10 rounded-full bg-accent/10 flex items-center justify-center">
            <ArrowRight className="w-5 h-5 text-accent rotate-90 md:rotate-0" />
          </div>

          {/* After */}
          <div className="card-depth p-8 w-full max-w-sm flex flex-col items-center gap-5">
            <div className="text-xs text-muted font-bold font-mono uppercase tracking-wider self-start">After</div>
            <StorageBarMockup
              progress={68}
              style="solid"
              width={260}
              height={28}
              animated
            />
            <span className="text-xs text-muted font-medium">Right in your menubar</span>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
