"use client";

import { useEffect, useRef } from "react";

export function MenubarMockup() {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    const dpr = window.devicePixelRatio || 1;
    const width = 520;
    const height = 64;
    canvas.width = width * dpr;
    canvas.height = height * dpr;
    canvas.style.width = `${width}px`;
    canvas.style.height = `${height}px`;
    ctx.scale(dpr, dpr);

    let animationId: number;
    let sweepX = -200;

    const draw = () => {
      ctx.clearRect(0, 0, width, height);

      // Menubar background - pill shaped
      const cornerRadius = 32;
      ctx.beginPath();
      ctx.moveTo(cornerRadius, 0);
      ctx.lineTo(width - cornerRadius, 0);
      ctx.quadraticCurveTo(width, 0, width, cornerRadius);
      ctx.lineTo(width, height - cornerRadius);
      ctx.quadraticCurveTo(width, height, width - cornerRadius, height);
      ctx.lineTo(cornerRadius, height);
      ctx.quadraticCurveTo(0, height, 0, height - cornerRadius);
      ctx.lineTo(0, cornerRadius);
      ctx.quadraticCurveTo(0, 0, cornerRadius, 0);
      ctx.closePath();

      // Gradient background like the blue menubar
      const bgGradient = ctx.createLinearGradient(0, 0, 0, height);
      bgGradient.addColorStop(0, "#6366F1");
      bgGradient.addColorStop(1, "#4F46E5");
      ctx.fillStyle = bgGradient;
      ctx.fill();

      // Subtle inner highlight
      ctx.save();
      ctx.beginPath();
      ctx.moveTo(cornerRadius, 1);
      ctx.lineTo(width - cornerRadius, 1);
      ctx.quadraticCurveTo(width - 1, 1, width - 1, cornerRadius);
      ctx.strokeStyle = "rgba(255, 255, 255, 0.15)";
      ctx.lineWidth = 1;
      ctx.stroke();
      ctx.restore();

      // Left section icons and text
      let leftX = 32;

      // Draw battery icon (charging)
      ctx.save();
      ctx.translate(leftX, height / 2);
      ctx.strokeStyle = "rgba(255, 255, 255, 0.9)";
      ctx.lineWidth = 1.5;
      ctx.lineCap = "round";
      ctx.lineJoin = "round";
      
      // Battery body
      ctx.strokeRect(-10, -6, 20, 12);
      ctx.fillStyle = "rgba(255, 255, 255, 0.9)";
      ctx.fillRect(-8, -4, 12, 8);
      
      // Battery cap
      ctx.fillStyle = "rgba(255, 255, 255, 0.9)";
      ctx.fillRect(10, -3, 2, 6);
      
      // Charging plug icon overlay
      ctx.beginPath();
      ctx.moveTo(-2, -2);
      ctx.lineTo(2, 0);
      ctx.lineTo(-2, 2);
      ctx.stroke();
      ctx.restore();
      leftX += 40;

      // Draw back arrow
      ctx.save();
      ctx.translate(leftX, height / 2);
      ctx.strokeStyle = "rgba(255, 255, 255, 0.85)";
      ctx.lineWidth = 2.5;
      ctx.lineCap = "round";
      ctx.lineJoin = "round";
      ctx.beginPath();
      ctx.moveTo(5, -7);
      ctx.lineTo(-3, 0);
      ctx.lineTo(5, 7);
      ctx.stroke();
      ctx.restore();
      leftX += 32;

      // Progress bar container - pill shaped
      const barX = leftX + 10;
      const barY = height / 2 - 11;
      const barW = 220;
      const barH = 22;
      const barRadius = 11;

      // Bar outer glow
      ctx.save();
      ctx.shadowColor = "rgba(255, 255, 255, 0.25)";
      ctx.shadowBlur = 12;
      ctx.beginPath();
      ctx.roundRect(barX, barY, barW, barH, barRadius);
      ctx.fillStyle = "rgba(255, 255, 255, 0.12)";
      ctx.fill();
      ctx.restore();

      // Bar track
      ctx.beginPath();
      ctx.roundRect(barX, barY, barW, barH, barRadius);
      ctx.fillStyle = "rgba(255, 255, 255, 0.18)";
      ctx.fill();
      ctx.strokeStyle = "rgba(255, 255, 255, 0.25)";
      ctx.lineWidth = 1.2;
      ctx.stroke();

      // Bar fill (about 60%) - rounded edges
      const fillW = barW * 0.6;
      const fillRadius = Math.min(barRadius, fillW / 2);
      
      // White fill with gradient
      const fillGradient = ctx.createLinearGradient(barX, barY, barX, barY + barH);
      fillGradient.addColorStop(0, "rgba(255, 255, 255, 0.95)");
      fillGradient.addColorStop(1, "rgba(255, 255, 255, 0.75)");
      
      ctx.beginPath();
      ctx.roundRect(barX, barY, fillW, barH, fillRadius);
      ctx.fillStyle = fillGradient;
      ctx.fill();
      
      // Highlight on top
      ctx.beginPath();
      ctx.roundRect(barX, barY, fillW, barH * 0.5, [fillRadius, fillRadius, 0, 0]);
      ctx.fillStyle = "rgba(255, 255, 255, 0.25)";
      ctx.fill();

      // Light sweep effect across the entire bar
      const sweepGradient = ctx.createLinearGradient(
        barX + sweepX - 80,
        0,
        barX + sweepX + 80,
        0
      );
      sweepGradient.addColorStop(0, "rgba(255, 255, 255, 0)");
      sweepGradient.addColorStop(0.3, "rgba(255, 255, 255, 0.3)");
      sweepGradient.addColorStop(0.5, "rgba(255, 255, 255, 0.8)");
      sweepGradient.addColorStop(0.7, "rgba(255, 255, 255, 0.3)");
      sweepGradient.addColorStop(1, "rgba(255, 255, 255, 0)");

      ctx.save();
      ctx.beginPath();
      ctx.roundRect(barX, barY, barW, barH, barRadius);
      ctx.clip();
      ctx.fillStyle = sweepGradient;
      ctx.fillRect(barX + sweepX - 120, barY - 5, 240, barH + 10);
      ctx.restore();

      // Glow dot at end of fill
      ctx.save();
      ctx.beginPath();
      ctx.arc(barX + fillW - 3, barY + barH / 2, 3, 0, Math.PI * 2);
      ctx.fillStyle = "rgba(255, 255, 255, 0.9)";
      ctx.shadowColor = "rgba(255, 255, 255, 0.9)";
      ctx.shadowBlur = 10;
      ctx.fill();
      ctx.restore();

      // Right section - Date
      const dateX = width - 110;
      ctx.save();
      ctx.font = "500 13px -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif";
      ctx.fillStyle = "rgba(255, 255, 255, 0.9)";
      ctx.textAlign = "left";
      ctx.textBaseline = "middle";
      ctx.fillText("Thu 7 May", dateX, height / 2);
      ctx.restore();

      // Animate sweep
      sweepX += 3;
      if (sweepX > barW + 150) {
        sweepX = -150;
      }

      animationId = requestAnimationFrame(draw);
    };

    draw();

    return () => {
      cancelAnimationFrame(animationId);
    };
  }, []);

  return (
    <div className="relative">
      <canvas
        ref={canvasRef}
        className="rounded-[32px]"
        style={{
          boxShadow: "0 8px 32px rgba(79, 70, 229, 0.25), 0 2px 8px rgba(0, 0, 0, 0.08)",
        }}
      />
    </div>
  );
}
