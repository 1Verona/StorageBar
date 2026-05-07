"use client";

import Image from "next/image";
import { motion } from "framer-motion";
import { Timer, Check } from "lucide-react";
import { StorageBarMockup } from "../components/StorageBarMockup";

export function CTA() {
  return (
    <section className="slide">
      <div className="max-w-3xl w-full flex flex-col items-center gap-10 px-4 text-center">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 0.8 }}
          className="flex flex-col items-center gap-5"
        >
          <motion.div
            animate={{
              boxShadow: [
                "0 8px 32px rgba(126,211,33,0.25)",
                "0 12px 48px rgba(126,211,33,0.4)",
                "0 8px 32px rgba(126,211,33,0.25)",
              ],
            }}
            transition={{ duration: 2, repeat: Infinity }}
            className="rounded-[32px] p-2 bg-white/80"
          >
            <Image
              src="/icon.png"
              alt="StorageBar"
              width={90}
              height={90}
              className="rounded-[28px]"
            />
          </motion.div>

          <h2 className="text-5xl sm:text-6xl font-bold text-foreground font-display">
            Ready to clean up
            <br />
            <span className="text-accent-green">your menubar?</span>
          </h2>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.3, duration: 0.6 }}
          className="flex flex-col items-center gap-4"
        >
          <StorageBarMockup
            progress={100}
            style="solid"
            color="#7ED321"
            width={320}
            height={32}
            animated
          />
          <span className="text-xs text-muted font-bold font-mono">Your disk is 100% visible now</span>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.5, duration: 0.6 }}
          className="flex flex-col items-center gap-6"
        >
          <div className="flex items-baseline gap-3">
            <span className="text-6xl font-bold text-foreground">$2</span>
            <span className="text-muted text-lg">one-time</span>
          </div>

          <div className="flex items-center gap-2 text-sm text-muted font-medium">
            <div className="w-8 h-8 rounded-xl bg-accent/10 flex items-center justify-center">
              <Timer className="w-4 h-4 text-accent" />
            </div>
            <span>24-hour free trial on first launch</span>
          </div>

          <ul className="flex flex-wrap justify-center gap-x-8 gap-y-3 text-sm font-medium">
            {[
              "Lifetime updates",
              "All features included",
              "3 devices per license",
            ].map((item) => (
              <li key={item} className="flex items-center gap-2">
                <div className="w-5 h-5 rounded-full bg-accent-green/20 flex items-center justify-center">
                  <Check className="w-3 h-3 text-accent-green" />
                </div>
                {item}
              </li>
            ))}
          </ul>
        </motion.div>

        <motion.a
          href="https://veronajoe.gumroad.com/l/StorageBar"
          target="_blank"
          rel="noopener noreferrer"
          data-no-drag
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.7 }}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          className="inline-flex items-center gap-3 px-10 py-5 rounded-full text-lg font-bold bg-accent text-white animate-pulse-cta shadow-[0_8px_32px_rgba(255,140,66,0.4)] hover:shadow-[0_12px_48px_rgba(255,140,66,0.55)] transition-shadow"
        >
          Get StorageBar on Gumroad
        </motion.a>
      </div>
    </section>
  );
}
