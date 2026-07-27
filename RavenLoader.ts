// Type definitions for Raven Framework
declare namespace Raven {
    interface Config {
        FrameworkName: string;
        Version: string;
        Sources: Source[];
        UI: UIConfig;
        RetryAttempts: number;
        RetryDelay: number;
    }

    interface Source {
        name: string;
        url: string;
        priority: number;
    }

    interface UIConfig {
        LoadingColor: Color3;
        SuccessColor: Color3;
        ErrorColor: Color3;
        TextColor: Color3;
        BackgroundColor: Color3;
    }

    interface LoaderAPI {
        StartLoad(): void;
        Cancel(): void;
        IsLoading: boolean;
        UI: LoaderUI;
    }

    interface LoaderUI {
        Create(): void;
        Destroy(): void;
        SetStatus(text: string, color?: Color3): void;
        SetProgress(percent: number, text?: string): void;
        ShowSpinner(show: boolean): void;
        ShowRetry(show: boolean): void;
        IsVisible: boolean;
        IsLoading: boolean;
    }
}

// Global instance
declare const RavenLoader: Raven.LoaderAPI;
