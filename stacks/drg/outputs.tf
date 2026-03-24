output "drg_id" {
  description = "Pasar este valor como variable drg_id en stacks/prod, dev, test y lab (sin hardcodear OCIDs en el código)."
  value       = module.drg.drg_id
}
