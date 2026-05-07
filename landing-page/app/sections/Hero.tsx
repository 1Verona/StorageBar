"use client";

import Image from "next/image";
import { motion } from "framer-motion";
import { MenubarMockup } from "../components/MenubarMockup";

export function Hero() {
  return (
    <section className="slide flex-col gap-10">
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.5 }}
        transition={{ duration: 0.8 }}
        className="flex flex-col items-center gap-8 text-center"
      >
        <motion.div
          animate={{ 
            boxShadow: [
              "0 8px 32px rgba(255,140,66,0.15)", 
              "0 12px 48px rgba(255,140,66,0.25)", 
              "0 8px 32px rgba(255,140,66,0.15)"
            ] 
          }}
          transition={{ duration: 3, repeat: Infinity }}
          className="rounded-[32px]"
        >
          <Image
            src="/icon.png"
            alt="StorageBar"
            width={120}
            height={120}
            className="rounded-[28px]"
            priority
          />
        </motion.div>

        <div>
          <h1 className="text-5xl sm:text-7xl font-bold tracking-tight mb-4 text-foreground font-display">
            StorageBar
          </h1>
          <p className="text-xl sm:text-2xl text-muted max-w-lg mx-auto leading-relaxed">
            Disk usage at a glance, right in your menubar.
          </p>
        </div>
      </motion.div>

      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        whileInView={{ opacity: 1, scale: 1 }}
        viewport={{ once: true, amount: 0.5 }}
        transition={{ duration: 0.8, delay: 0.3 }}
        className="flex flex-col items-center gap-6"
      >
        <MenubarMockup />
      </motion.div>

      <motion.p
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true }}
        transition={{ delay: 0.8 }}
        className="text-sm text-muted font-medium animate-bounce"
      >
        Scroll or drag to explore →
      </motion.p>
    </section>
  );
}
