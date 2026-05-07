"use client";

import { motion } from "framer-motion";
import { Palette } from "lucide-react";
import { StorageBarMockup } from "../components/StorageBarMockup";

const styles = [
  { style: "solid" as const, label: "Solid", desc: "Preenchimento sólido dentro de um trilho de fundo", color: "#7ED321" },
  { style: "outline" as const, label: "Outline", desc: "Borda visível ao redor da barra, sem fundo", color: "#FF8C42" },
  { style: "track" as const, label: "Track", desc: "Fundo de trilho visível com preenchimento colorido", color: "#FF6B9D" },
  { style: "pill-percent" as const, label: "Pill + %", desc: "Barra com texto de porcentagem dentro", color: "#3498DB" },
  { style: "track-outline" as const, label: "Track Outline", desc: "Combinação de trilho de fundo + borda visível", color: "#1ABC9C" },
  { style: "gradient" as const, label: "Gradient", desc: "Preenchimento com gradiente verde→laranja", color: "#7ED321" },
  { style: "minimal" as const, label: "Minimal", desc: "Linha horizontal mínima de 3px, sem fundo", color: "#E67E22" },
];

export function Styles() {
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
              <Palette className="w-5 h-5 text-accent" />
            </div>
            <span className="text-sm font-bold font-mono uppercase tracking-wider">7 Styles</span>
          </div>
          <h2 className="text-4xl sm:text-5xl font-bold mb-4 text-foreground font-display">
            Pick your look
          </h2>
          <p className="text-muted text-lg max-w-lg mx-auto leading-relaxed">
            From minimal lines to glowing pills. Find the style that matches your setup.
          </p>
        </motion.div>

        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5 w-full max-w-4xl">
          {styles.map((s, i) => (
            <motion.div
              key={s.label}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, amount: 0.3 }}
              transition={{ duration: 0.5, delay: i * 0.08 }}
              className="card-depth p-6 flex flex-col items-center gap-4 hover:scale-[1.03] transition-transform"
            >
              <StorageBarMockup
                progress={[62, 45, 78, 55, 70, 65, 50][i]}
                style={s.style}
                color={s.color}
                width={160}
                height={22}
                animated
              />
              <div className="text-center">
                <span className="text-sm text-foreground font-bold block">{s.label}</span>
                <span className="text-[10px] text-muted leading-tight block mt-1">{s.desc}</span>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
