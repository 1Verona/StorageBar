"use client";

import { useRef, useEffect, useCallback, useState } from "react";

interface UseHorizontalScrollReturn {
  containerRef: React.RefObject<HTMLDivElement | null>;
  scrollProgress: number;
}

export function useHorizontalScroll(): UseHorizontalScrollReturn {
  const containerRef = useRef<HTMLDivElement>(null);
  const [scrollProgress, setScrollProgress] = useState(0);
  const isDragging = useRef(false);
  const startX = useRef(0);
  const scrollLeft = useRef(0);

  const updateProgress = useCallback(() => {
    const el = containerRef.current;
    if (!el) return;
    const maxScroll = el.scrollWidth - el.clientWidth;
    const progress = maxScroll > 0 ? el.scrollLeft / maxScroll : 0;
    setScrollProgress(Math.min(1, Math.max(0, progress)));
  }, []);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    const onWheel = (e: WheelEvent) => {
      e.preventDefault();
      el.scrollLeft += e.deltaY + e.deltaX;
      updateProgress();
    };

    const onMouseDown = (e: MouseEvent) => {
      if ((e.target as HTMLElement).closest("[data-no-drag]")) return;
      isDragging.current = true;
      startX.current = e.pageX - el.offsetLeft;
      scrollLeft.current = el.scrollLeft;
      el.classList.add("cursor-grabbing");
      el.classList.remove("cursor-grab");
    };

    const onMouseUp = () => {
      isDragging.current = false;
      el.classList.remove("cursor-grabbing");
      el.classList.add("cursor-grab");
      snapToNearestSlide();
    };

    const onMouseMove = (e: MouseEvent) => {
      if (!isDragging.current) return;
      e.preventDefault();
      const x = e.pageX - el.offsetLeft;
      const walk = (x - startX.current) * 1.5;
      el.scrollLeft = scrollLeft.current - walk;
      updateProgress();
    };

    const onTouchStart = () => {
      // Let native touch scroll handle it, just update progress
    };

    const onTouchMove = () => {
      requestAnimationFrame(updateProgress);
    };

    const onTouchEnd = () => {
      setTimeout(snapToNearestSlide, 100);
    };

    const onKeyDown = (e: KeyboardEvent) => {
      const slideWidth = el.clientWidth;
      if (e.key === "ArrowRight") {
        el.scrollTo({ left: el.scrollLeft + slideWidth, behavior: "smooth" });
      } else if (e.key === "ArrowLeft") {
        el.scrollTo({ left: el.scrollLeft - slideWidth, behavior: "smooth" });
      }
    };

    const snapToNearestSlide = () => {
      const slideWidth = el.clientWidth;
      const currentSlide = Math.round(el.scrollLeft / slideWidth);
      const targetScroll = currentSlide * slideWidth;
      el.scrollTo({ left: targetScroll, behavior: "smooth" });
      setTimeout(updateProgress, 300);
    };

    el.addEventListener("wheel", onWheel, { passive: false });
    el.addEventListener("mousedown", onMouseDown);
    window.addEventListener("mouseup", onMouseUp);
    window.addEventListener("mousemove", onMouseMove);
    el.addEventListener("touchstart", onTouchStart, { passive: true });
    el.addEventListener("touchmove", onTouchMove, { passive: true });
    el.addEventListener("touchend", onTouchEnd, { passive: true });
    window.addEventListener("keydown", onKeyDown);
    el.addEventListener("scroll", updateProgress, { passive: true });

    return () => {
      el.removeEventListener("wheel", onWheel);
      el.removeEventListener("mousedown", onMouseDown);
      window.removeEventListener("mouseup", onMouseUp);
      window.removeEventListener("mousemove", onMouseMove);
      el.removeEventListener("touchstart", onTouchStart);
      el.removeEventListener("touchmove", onTouchMove);
      el.removeEventListener("touchend", onTouchEnd);
      window.removeEventListener("keydown", onKeyDown);
      el.removeEventListener("scroll", updateProgress);
    };
  }, [updateProgress]);

  return { containerRef, scrollProgress };
}
