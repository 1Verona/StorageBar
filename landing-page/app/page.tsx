"use client";

import { useHorizontalScroll } from "./hooks/useHorizontalScroll";
import { ProgressBar } from "./components/ProgressBar";
import { BottomBar } from "./components/BottomBar";
import { Hero } from "./sections/Hero";
import { Problem } from "./sections/Problem";
import { Customize } from "./sections/Customize";
import { QuickClean } from "./sections/QuickClean";
import { CTA } from "./sections/CTA";

export default function Home() {
  const { containerRef, scrollProgress } = useHorizontalScroll();

  return (
    <div className="h-full w-full relative">
      <ProgressBar progress={scrollProgress} />

      <div
        ref={containerRef}
        className="h-full w-full overflow-x-auto overflow-y-hidden hide-scrollbar cursor-grab flex flex-row"
      >
        <Hero />
        <Problem />
        <Customize />
        <QuickClean />
        <CTA />
      </div>

      <BottomBar progress={scrollProgress} />
    </div>
  );
}
