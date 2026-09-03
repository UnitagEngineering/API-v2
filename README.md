# API V2

> 📘 **Interactive reference:** this API is now described by an OpenAPI 3.1 spec
> ([`openapi.yaml`](./openapi.yaml)), rendered with Scalar. See [`DEPLOY.md`](./DEPLOY.md)
> for hosting. The spec is the source of truth; this README is kept as a human-readable mirror.

## Introduction

Unitag provides a simple yet powerful REST API to integrate the generation of QR Codes in your application

## General

### Data Centers

Our services are hosted in Amazon Ireland (eu-west-1) and OVH France

### Sandbox

A public sandbox is available for testing the generation of QR Codes. In this environment you are limited to 1000 calls per day, if additional operations are needed please contact our support. In addition, any QR Code created will be deleted after 6 months, upon scanning they will return an HTTP 404 from our resolvers.

Those limitations reset every day at midnight (00:00am) GMT

#### Sandbox URLs

When testing your API connectivity make sure to use the following URLs:

REST API  

https://api-v2.sandbox.unitag.io

## Content

* [QR codes](#qr-codes)
  * [Preview a QR code](#preview-a-qr-code-design)
  * [Create a QR code](#create-a-qr-code)
  * [Retrieve a QR code](#retrieve-a-qr-code)
  * [Retrieve all QR codes](#retrieve-all-qr-codes)
  * [Update a QR code URL](#update-a-qr-code-destination-url)
  * [Update a QR code label](#update-a-qr-code-label)
  * [Delete a QR code](#delete-a-qr-code)
  * [Download a QR code](#download-a-qr-code)
  * [Download multiple QR codes](#download-multiple-qr-codes)
* [Templates](#templates)
  * [Retrieve templates](#retrieve-qr-code-templates)
  * [Create a template](#create-a-template-from-a-qr-code)
  * [Update a template](#update-a-template)
  * [Delete a template](#delete-a-template)
* [Filters](#filters)
  * [Create a filter](#create-a-filter)
  * [Retrieve filters](#retrieve-filters-for-a-qr-code)
  * [Update a filter](#update-a-filter)
  * [Delete a filter](#delete-a-filter)
* [GS1 Digital Link](#gs1-digital-link)
  * [Supported identifiers](#supported-identifiers)
  * [Build a Digital Link path](#build-a-digital-link-path)
  * [Create a GS1 Digital Link QR code](#create-a-gs1-digital-link-qr-code)
  * [Typed destinations (link types)](#typed-destinations-link-types)
  * [Resolver behaviour](#resolver-behaviour)
* [Scheduled destination changes](#scheduled-destination-changes)
  * [Create a schedule](#create-a-schedule)
  * [List schedules](#list-schedules)
  * [Retrieve a schedule](#retrieve-a-schedule)
  * [Update a schedule](#update-a-schedule)
  * [Delete a schedule](#delete-a-schedule)
* [Domain names](#domain-names)
  * [Register a domain](#register-a-domain-name)
  * [Validate a domain](#validate-a-domain-name)
  * [Retrieve domains](#list-all-domain-names-available)
  * [Retrieve a domain](#retrieve-a-domain-name)
  * [Retrieve DNS configuration](#retrieve-a-domains-dns-configuration)
  * [Set kind and region](#set-a-domains-kind-and-region)
  * [Share a domain](#share-a-domain-name)
  * [Delete a domain](#delete-a-domain-name)
* [Campaigns](#campaigns)
  * [List campaigns](#list-campaigns)
  * [Create a campaign](#create-a-campaign)
  * [Create a sub-campaign](#create-a-sub-campaign)
  * [Update a campaign](#update-a-campaign)
  * [Get campaign assets count](#get-campaign-assets-count)
  * [Delete a campaign](#delete-a-campaign)
* [Analytics](#analytics)
  * [Retrieve aggregated stats](#retrieve-qr-codes-aggregated-stats)
  * [Retrieve visit records](#retrieve-visit-records)
  * [Export analytics](#export-analytics)
  * [Retrieve vCard Pro stats](#retrieve-vcard-pro-aggregated-stats)
  * [Retrieve an organisation's stats](#retrieve-an-organisations-aggregated-stats)
  * [Retrieve one account holder's stats](#retrieve-one-account-holders-aggregated-stats)
* [Business Intelligence](#business-intelligence)
  * [Organisation scorecard](#organisation-scorecard)
  * [What drives your scans](#what-drives-your-scans)
  * [Scans per campaign](#scans-per-campaign)
  * [One campaign's detail](#one-campaigns-scorecard-and-drivers)
  * [Content insights](#scans-by-content-category-audience-and-language)
  * [Scans over time](#scans-over-time)
  * [Where your scans come from](#where-your-scans-come-from)
  * [Visitor behaviour](#visitor-behaviour)
  * [Outlying QR codes](#over--and-under-performing-qr-codes)
  * [Traffic quality](#bot-share-and-traffic-anomalies)
  * [Risk exposure](#qr-codes-flagged-as-risky)
  * [Sector benchmark](#compare-with-your-sector)
* [Audit](#audit)
  * [Organisation audit events](#list-an-organisations-audit-events)
  * [User audit events](#list-one-users-audit-events)
  * [Entity audit events](#list-one-entitys-audit-events)
  * [Export audit events](#export-audit-events)
* [Labels](#labels)
  * [List labels](#list-labels)
  * [Retrieve a label](#retrieve-a-label)
  * [Create a label](#create-a-label)
  * [Update a label](#update-a-label)
  * [Count QR codes per label](#count-qr-codes-per-label)
  * [Delete a label](#delete-a-label)
* [Groups](#groups)
  * [List groups](#list-groups)
  * [Retrieve a group](#retrieve-a-group)
  * [Create a group](#create-a-group)
  * [Update a group](#update-a-group)
  * [Delete a group](#delete-a-group)
* [vCards](#vcards)
  * [List vCards](#list-vcards)
  * [Create a vCard](#create-a-vcard)
* [Assets](#assets)
  * [Upload an asset](#upload-an-asset)
  * [Excavate a logo](#excavate-a-logo)
  * [List batch bundles](#list-batch-bundles)
  * [Delete a batch bundle](#delete-a-batch-bundle)
* [Batches](#batches)
  * [List batches](#list-batches)
* [Account](#account)
  * [Retrieve your account](#retrieve-your-account)

## API

The REST API endpoints are as follows:

REST API  

https://api-v2.unitag.io

### Requests

All requests and responses of *Content-Type* *application/json* and follow typical HTTP response status codes for success and failures

#### Errors

Every non-2xx response is `application/json` and carries the same body:

```json
{ "error_code": "NOT_FOUND", "message": "qrcodes not found" }
```

Switch on `error_code` — it is a stable value. `message` is human-readable prose and may be reworded without notice.

| Status Code | Reason | `error_code` |
| --- | --- | --- |
| 400 | Bad Request - Invalid request format | `BAD_REQUEST` |
| 401 | Unauthorized - Bad API key | `UNAUTHORIZED` |
| 403 | Forbidden - Insufficient rights or credits to perform the operation | `FORBIDDEN`, `UPGRADE_NEEDED`, `PLAN_LIMIT` |
| 404 | Not found - The resource cannot be found for the user | `NOT_FOUND` |
| 429 | Too many requests - Rate limit or monthly quota exceeded | `TOO_MANY_REQUESTS` |
| 500 | Internal error - Please contact our support | `INTERNAL_ERROR` |

Business conditions carry their own `error_code` alongside the generic one for the status — `UPGRADE_NEEDED` for a plan that does not cover the feature, for example.

#### Successes

A successful response is indicated by HTTP status code 200 and may contain an optional body. If the response has a body it will be documented under each resource below.

### Types

#### IDs

Most identifiers are UUID unless otherwise specified. When making a request which requires a UUID. Those UUIDs are based on RFC 4122 and DCE 1.1: Authentication and Security Services.

Example: *f81d4fae-7dec-11d0-a765-00a0c91e6bf6*

## Rate Limits

When a rate limit is exceeded, a status of *429 Too Many Requests* will be returned.

### Sandbox

1000 calls a day

### Production

1000000 calls a day

Each of those counters are reset every day at midnight (00:00am GMT)

## Authentication

### Generating an API Key

You can generate an API key from https://console.sandbox.unitag.io/settings section API.
In case of issue, please contact our Support Team (via the support button in your dashboard) in order to gain access to it and receive your credentials.

You can then call Unitag API endpoints by adding your API key as a header to the request such as:

```X-Unitag-ApiKey=<API-Key>```

### Environments

Upon creating your key you will have to choose the targeted environment accordingly. Environments are isolated, meaning that any asset created in one will not be duplicated or accessible to/from another environment.

## QR Codes

### Preview a QR Code design

Create a QR Code Preview for the profile of the API Key

**HTTP request**

`POST /qrcodes/preview`

**Request fields**

Example:
```json
{
  "data": {
    "type": "URL",
    "resolution": "dynamic",
    "url": "https://unitag.io"
  },
  "settings": {
    "template_id": "",
    "redundancy": "M",
    "eyes": {
      "type": "curved",
      "color_ext_top_left": "",
      "color_ext_top_right": "",
      "color_ext_bottom_left": "",
      "color_int_bottom_left": "",
      "color_int_top_right": "",
      "color_int_top_left": ""
    },
    "layout": {
      "gradient_type": "vertical",
      "type": "gradient",
      "color_background": "#ffffff",
      "color_one": "#53c1a6",
      "color_two": "#c9285a",
      "color_shadow": "#bdbdbd",
      "force_shadow": "none"
    },
    "logo": {
      "excavate": false,
      "url": "",
      "width": 0,
      "height": 0,
      "x": 0,
      "x_norm": 0,
      "y": 0,
      "y_norm": 0
    },
    "background": {
      "url": "",
      "contrast": 0,
      "brightness": 0
    },
    "modules": {
      "type": "simple"
    },
    "frame": {
      "style": "simple",
      "text_top": "",
      "text_bottom": "SCAN ME",
      "background_color": "#000000"
    }
  }
}
```

**Details**

*Data* object:

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| type | string | true | Type of QR Code, one of "url, vcard" |  
| resolution | string | true | Resolution of your QR Code, one of "dynamic, dynamic-pro, static" |
| url | string | true | Final URL to which your QR Code should redirect to upon scanning |
| domain_id | string | false | Mandatory if resolution type is "dynamic-pro" |
| preferred_short_url | string | false | Custom short URL segment (alphanumeric, no special characters) |

*Settings* object:

- *Layout* object:

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| type | string | true | One of "single_color, gradient, image_overlay" — controls how the QR **modules** are coloured/filled, **not** the logo (see note below) |
| color_one | string | false | Hexadecimal color for QR Code modules and eyes |
| color_two | string | false | Hexadecimal color for gradient end (only when type is "gradient") |
| color_background | string | false | Hexadecimal color for the background |
| gradient_type | string | false | One of "horizontal, vertical, diagonal, diagonal_inverted, radial" (only when type is "gradient") |
| color_shadow | string | false | Hexadecimal color for shadow |
| force_shadow | string | false | Shadow intensity, one of "S, M, L, none" |

> **Logo vs. `image_overlay` — these are independent features.**
> - To add a **logo** (a small image in the centre of the QR Code), use the *Logo* object below. It works with **any** `layout.type` — keep `type` as `single_color` or `gradient`. You do **not** need `image_overlay` for a logo.
> - `image_overlay` is a separate effect that fills the QR **modules themselves** with an image. It **requires** a *Background* object with a `url` (or `asset_uuid`); sending `type: "image_overlay"` without a background image returns `400`.

- *Eyes* object:

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| type | string | false | Type of Eye (see table below) |
| color_ext_top_left | string | false | Hexadecimal color for the external top-left eye |
| color_ext_top_right | string | false | Hexadecimal color for the external top-right eye |
| color_ext_bottom_left | string | false | Hexadecimal color for the external bottom-left eye |
| color_int_top_left | string | false | Hexadecimal color for the internal top-left eye |
| color_int_top_right | string | false | Hexadecimal color for the internal top-right eye |
| color_int_bottom_left | string | false | Hexadecimal color for the internal bottom-left eye |

Please read the table below which illustrates the different options:

| Eye type | Representation |
| --- | --- |
| simple | ![alt text](img/simple.png "simple") |
| diamond | ![alt text](img/diamond.png "diamond") |
| rounded | ![alt text](img/rounded.png "rounded") |
| rounded_light | ![alt text](img/rounded_light.png "rounded_light") |
| rounded_strong | ![alt text](img/rounded_strong.png "rounded_strong") |
| eye_right | ![alt text](img/eye_right.png "eye_right") |
| eye_left | ![alt text](img/eye_left.png "eye_left") |
| shield | ![alt text](img/shield.png "shield") |
| pillow | ![alt text](img/pillow.png "pillow") |
| star | ![alt text](img/star.png "star") |
| leaf | ![alt text](img/leaf.png "leaf") |
| sieve | ![alt text](img/sieve.png "sieve") |
| dots | ![alt text](img/dots.png "dots") |
| wave | ![alt text](img/wave.png "wave") |
| sharp | ![alt text](img/sharp.png "sharp") |
| curved | ![alt text](img/curved.png "curved") |
| tik_tak_toe | ![alt text](img/tik_tak_toe.png "tik_tak_toe") |
| octagonal | ![alt text](img/octagonal.png "octagonal") |
| alien | ![alt text](img/alien.png "alien") |
| grid | ![alt text](img/grid.png "grid") |
| square_diamond | ![alt text](img/square_diamond.png "square_diamond") |
| thin_circle | ![alt text](img/thin_circle.png "thin_circle") |

- *Modules* object:

| field | type | mandatory | description |  
| --- | --- | --- | --- |
| type | string | false | Type of Module (see table below) |

Please read the table below which illustrates the different options:

| Module type | Representation |
| --- | --- |
| simple | ![alt text](img/module_simple.png "simple") |
| rounded | ![alt text](img/module_rounded.png "rounded") |
| rounded_light | ![alt text](img/module_rounded_light.png "rounded_light") |
| rounded_strong | ![alt text](img/module_rounded_strong.png "rounded_strong") |
| sieve | ![alt text](img/module_sieve.png "sieve") |
| angular | ![alt text](img/module_angular.png "angular") |
| paint | ![alt text](img/module_paint.png "paint") |
| dots | ![alt text](img/module_dots.png "dots") |
| arrows | ![alt text](img/module_arrows.png "arrows") |
| styled | ![alt text](img/module_styled.png "styled") |
| rectangles | ![alt text](img/module_rectangles.png "rectangles") |
| tik_tak_toe | ![alt text](img/module_tik_tak_toe.png "tik_tak_toe") |
| connections | ![alt text](img/module_connections.png "connections") |
| shinny | ![alt text](img/module_shinny.png "shinny") |
| diamonds | ![alt text](img/module_diamonds.png "diamonds") |
| small_circles | ![alt text](img/module_small_circles.png "small_circles") |

- *Background* object:

> Attention:   
> The overlay will apply an image on your QR Code, we recommend using a 300px by 300px image with a sufficient contrast against your background color or your QR Code my not be readable by native scanners
>
> This *Background* object is only used when `layout.type` is `image_overlay`, and is **required** in that case. It is **not** how you add a logo — for a logo, use the *Logo* object instead.

| field | type | mandatory | description |  
| --- | --- | --- | --- |
| url | string | false | The URL of your remote asset to use as overlay |
| brightness | float | false | From 0.0 to 1.0 (default 0.5), brightness will be applied on your asset |
| contrast | float | false | From 0.0 to 1.0 (default 0.5), contrast that will be applied on your asset |

- *Logo* object:

> Attention:  
> A logo is an image present in your QR Code that hides some information, thanks to our QR Code redundancy it should have no effect on the QR Code readability. But, a logo too big or misplaced can render your QR Code unreadable

> The logo is added by including this *Logo* object. It is **independent of `layout.type`** — keep `type` as `single_color` (or `gradient`); you do not need `image_overlay`. To simply place a logo in the centre, send the `url` and `width` and omit `x_norm`/`y_norm` — the logo defaults to the QR centre.

| field | type | mandatory | description |  
| --- | --- | --- | --- |
| excavate | boolean | false | (default: false) Controls how the logo sits on the QR Code. `true`: the QR **modules under the logo are removed** (excavated), so the logo shows inside a clear/white zone. `false`: the logo is **drawn directly on top of the modules**, with no excavation. |
| x | number | false | Absolute origin position in pixels on the x axis in the QR Code |
| y | number | false | Absolute origin position in pixels on the y axis in the QR Code |
| x_norm | number | false | Normalized x position offset (defaults to 0 = centred when omitted) |
| y_norm | number | false | Normalized y position offset (defaults to 0 = centred when omitted) |
| width | number | false | Width in pixels of your logo |
| height | number | false | Height in pixels of your logo |
| url | string | false | The URL of your remote asset to use as logo |

- *Frame* object (optional):

> Frames add a decorative border with text around your QR Code. The frame is rendered server-side and included in the output image.

| field | type | mandatory | description |  
| --- | --- | --- | --- |
| style | string | true | Frame style (see list below) |
| text_top | string | false | Text displayed above the QR Code (supported by some styles) |
| text_bottom | string | false | Text displayed below the QR Code |
| background_color | string | false | Hexadecimal color for the frame (default: black) |

Available frame styles: `simple`, `beverage`, `banner`, `filled_card`, `callout_filled`, `callout_top`, `dashed_border`, `inline`, `scan`, `rounded`, `banner_ribbon`, `phone_scan`, `phone_screen`

Styles that support independent `text_top`: `simple`, `beverage`, `banner`, `filled_card`, `callout_top`, `dashed_border`. Other styles render a single text using `text_bottom`.

**Response**

Content-Type: image/png

The preview image of the resulted QR Code

**Response headers**

| header | description |
| --- | --- |
| X-Unitag-Generator | "CONTRAST_WARNING" if the QR Code colors may cause scan issues, "OK" otherwise |
| X-Unitag-Logo-Too-Big | "true" if the logo exceeds recommended size for scan readability |

---
### Create a QR Code

Create a QR Code for the profile of the API Key

**HTTP request**

`POST /qrcode`

**Request fields**

Example
```json
{
  "data": {
    "type": "url",
    "resolution": "dynamic",
    "url": "https://example.com/my-page",
    "label": "My first QR code"
  },
  "settings": {
    "layout": {
      "type": "single_color",
      "color_one": "#000000",
      "color_background": "#ffffff"
    },
    "eyes": {
      "type": "simple"
    },
    "modules": {
      "type": "simple"
    },
    "logo": {
      "excavate": false,
      "width": 60,
      "url": "https://example.com/my-logo.png"
    }
  }
}
```

> The example above adds a centred logo on a single-colour QR Code (the most common case). The logo lives in the `logo` object and does **not** require `image_overlay`; `x_norm`/`y_norm` are omitted so the logo is centred. See the **Logo vs. `image_overlay`** note in the *QR Code Preview* section.

Example of data payload with Dynamic Pro

```json
{
  "data": {
    "type": "url",
    "resolution": "dynamic-pro",
    "domain_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "url": "https://example.com/my-page",
    "[...]": "[...]"
  }
}
```

Example of data payload with a Campaign associated to the QR code at its creation

```json
{
  "data": {
    "type": "url",
    "resolution": "dynamic",
    "url": "https://example.com/my-page",
    "label": "My first QR code",
    "campaign": {
      "uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc"
    }
  },
  "settings": {
    "layout": {
      "type": "single_color",
      "color_one": "#000000",
      "color_background": "#ffffff"
    },
    "eyes": {
      "type": "simple"
    },
    "modules": {
      "type": "simple"
    },
    "logo": {
      "excavate": false,
      "width": 60,
      "url": "https://example.com/my-logo.png"
    }
  }
}
```

Example with an **image overlay** (the QR modules are filled with an image — this is the only case that uses `image_overlay`, and a `background` image is **required**; note there is no `logo` here):

```json
{
  "data": {
    "type": "url",
    "resolution": "dynamic",
    "url": "https://example.com/my-page"
  },
  "settings": {
    "layout": {
      "type": "image_overlay",
      "color_background": "#ffffff"
    },
    "eyes": {
      "type": "simple"
    },
    "modules": {
      "type": "simple"
    },
    "background": {
      "url": "https://example.com/my-asset.png",
      "brightness": 0.5,
      "contrast": 0.5
    }
  }
}
```

**Details**

*Data* object:

| field      | type | mandatory | description                                                     |  
|------------| --- | --- |-----------------------------------------------------------------|  
| type       | string | true | Type of QR Code, one of "url, vcard"                            |  
| resolution | string | true | Resolution of your QR Code, one of "dynamic, dynamic-pro, static" |
| domain_id  | string | false | Mandatory if resolution type is "dynamic-pro"                   | 
| url        | string | true | Final URL to which your QR Code should redirect to upon scanning |
| label      | string | false | Name for your QR code                                           |
| preferred_short_url | string | false | Custom short URL segment (alphanumeric, no special characters) |
| campaign   | object | false | Campaign to associate with the QR code (contains `uuid` field) |

*Settings* object:

For more details about the settings object please refer to the *Settings* object in the **QR Code Preview** section

**Response fields**

Example

```json
{
  "status": "created",
  "qrcode_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "content_url": "https://qrcode.link/a/f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "qrcode_image_url": "https://cdn-public.unitag.io/aaaaaaa-7dec-11d0-a765-00a0c91e6bf6/preview.png"
}
```

| field | type | description                                                                |
| --- | --- |----------------------------------------------------------------------------|
| status | string | Status of the QR Code, one of "created, updated"                           |
| qrcode_id | string | ID of the QR Code created                                                  |
| content_url | string | Resolution URL, your own domain name if resolution is set to "dynamic-pro" |
| short_url | string | Repeats content_url. Populated by `POST /qrcode/serial`; empty on this endpoint |
| qrcode_image_url | string | QR Code image available from our CDN                                       |

---

### Retrieve a QR Code

Retrieve a QR Code via its ID

**HTTP request**

```GET /qrcode/<qrcode_id>```

---

### Retrieve all QR Codes

Retrieve all QR Codes associated with the account

**HTTP request**

```GET /qrcodes/paginated?page=1&sortField=creation_date&sortOrder=desc&maxRows=5```

Above is request with default args.

Parameters:

- sortField [field to sort with, one of Label, Destination, Campaign, Organisation, creation_date, short_url]
- sortOrder [desc/asc]
- filterLabel [string, partial search allowed]
- filterDestination [string, partial search allowed]
- filterCampaign [campaign_uuid]
- filterOrganisation [organisation_uuid]
- filterDate [string, dd/mm/yyyy]
- filterType [string, type of QR code]
- filterShortUrl [string, partial search allowed]
- filterBatchId [batchID]
- maxRows [integer]

---

### Update a QR Code destination URL

Update the destination URL of a QR Code

> This request is only available for Dynamic and Dynamic Pro QR Codes

**HTTP request**

```PUT /qrcode/<qrcode_id>/url```

**Request fields**

Example 

```json
{
  "url": "https://unitag.io/features"
}
```

*Data* object:

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| url | string | true | The final URL of your QR Code |

---

### Update a QR Code label

Update the label (name) of a QR Code

**HTTP request**

```PUT /qrcode/<qrcode_id>/label```

**Request fields**

```json
{
  "label": "My updated QR code name"
}
```

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| label | string | true | The new label for your QR Code |

**Response**

```json
{
  "status": "updated"
}
```

---

### Delete a QR Code

Delete a QR Code

**HTTP request**

```DELETE /qrcode/<qr_code_uuid>```

---

### Download a QR Code

Download a QR Code in multiple formats

**HTTP request**

```
POST /asset/download/qrcode_bundle
```

**Request fields**

Example single download

```json
{
  "asset_uuid": "<qrcode_id>",
  "format": "png",
  "size": 300,
  "unit": "px"
}
```

Example with frame

```json
{
  "asset_uuid": "<qrcode_id>",
  "format": "png",
  "size": 300,
  "unit": "px",
  "hasFrame": true,
  "frame": {
    "style": "simple",
    "text_top": "",
    "text_bottom": "SCAN ME",
    "background_color": "#000000"
  }
}
```

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| asset_uuid | string | true | Asset ID to be downloaded |
| format | string | true | Desired output format, one of "png", "svg", "jpeg", "pdf" |
| size | number | true | Desired output size, range between 100 and 2500 |
| unit | string | true | Desired output unit, one of "px", "mm" |
| color_profile | string | false | One of "RGB" (default), "GRAYSCALE" |
| hasFrame | boolean | false | Whether to include a frame around the QR Code |
| frame | object | false | Frame settings (see Frame object in Preview section) |

**Response**

Binary output matching your request representing the image of your asset

---

### Download multiple QR Codes

```
POST /asset/download/export
```

Example batch download

```json
{
  "qrcode_ids": ["<qrcode_id_1>", "<qrcode_id_2>", "<qrcode_id_3>"],
  "format": "png",
  "size": 300,
  "unit": "px"
}
```

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| qrcode_ids | Array of string | true | Assets ID to be downloaded |
| format | string | true | Desired output format, one of "png", "svg", "jpeg", "pdf" |
| size | number | true | Desired output size, range between 100 and 2500 |
| unit | string | true | Desired output unit, one of "px", "mm" |
| color_profile | string | false | One of "RGB" (default), "GRAYSCALE" |
| hasFrame | boolean | false | Whether to include a frame around each QR Code |
| frame | object | false | Frame settings (see Frame object in Preview section) |

**Response**

A compressed archive (zip) containing all your assets

---

## Templates

Templates allow you to save and reuse QR Code designs.

### Retrieve QR Code templates

Retrieve the list of existing templates

**HTTP request**

```
GET /qrcodes/templates
```

**Response**

An array of template objects with their UUIDs, names, and associated design.

When creating a QR code using a template design, pass the UUID of the template to the POST create QR Code request:

```json
{
    "settings": {
        "redundancy": "H",
        "template_id": "c7a5dc7c-4bcb-435d-a5a3-b21658189f7a"
    },
    "data": {
        "type": "url",
        "resolution": "dynamic",
        "url": "https://example.com"
    }
}
```

---

### Create a template from a QR Code

Save a QR Code's design as a reusable template

**HTTP request**

```POST /qrcode/<qrcode_id>/template```

**Request fields**

```json
{
  "template_name": "My template"
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| template_name | string | true | Name for the template |

**Response**

```json
{
  "template_id": "c7a5dc7c-4bcb-435d-a5a3-b21658189f7a"
}
```

---

### Update a template

Update the name of an existing template

**HTTP request**

```PUT /qrcodes/template/<template_id>```

**Request fields**

```json
{
  "name": "Updated template name"
}
```

**Response**

```json
{
  "status": "updated",
  "uuid": "c7a5dc7c-4bcb-435d-a5a3-b21658189f7a",
  "name": "Updated template name"
}
```

---

### Delete a template

**HTTP request**

```DELETE /qrcodes/template/<template_id>```

---

## Filters

> NB: Filters are only available for Dynamic and Dynamic Pro QR Codes

Filters are a way to redirect your users based on certain conditions. Those conditions are evaluated upon scanning a QR Code. If those conditions are fulfilled the filter will be triggered

Filters available:
* Language based
* Device based
* Location based (module required)
* Combination of all the above

On GS1 Digital Link QR codes a filter can additionally carry a `link_type`, which turns it into a
*typed* destination rather than a plain conditional redirection — see
[Typed destinations](#typed-destinations-link-types).

> **Time-based changes are not filters.** A filter is evaluated on every scan, against properties of
> the scan itself (device, language, country). To change where a code points at a given date and
> time, use a [schedule](#scheduled-destination-changes) instead: it rewrites the destination once,
> when the moment arrives.

### Create a Filter

**HTTP request**

```POST /qrcode/<qrcode_id>/filter```

**Request fields**

Example

In this example we are creating a language filter which is read as followed:
If an english speaker scans this QR Code it will be redirected to https://www.unitag.io/welcome

```json
{
  "final_url": "https://www.unitag.io/welcome",
  "statements": [
    {
      "type": "language",
      "value": "en"
    }
  ]
}
```

**Details**

*Filter* object:

| field      | type               | mandatory | description                                                     |  
|------------|--------------------| --- |-----------------------------------------------------------------|  
| final_url  | string             | true | The destination URL used if the filter statements are fulfilled |
| statements | Array of Statement | true | List of Statements for the filter                               | 
| link_type  | string             | false | GS1 Web Vocabulary link type. Makes this a *typed* GS1 destination. GS1 codes only — see [Typed destinations](#typed-destinations-link-types) |
| active     | boolean            | false | Whether the resolver may select this destination. Defaults to `true` on create; omitting it on update leaves the current value unchanged |

*Statement* object:

| field | type | mandatory | description                                                                 |  
|-------| --- | --- |-------------------------------------------------------------------------------|  
| type  | string | true | Type of Statement, one of "device", "language", "location_country", "context" |  
| value | string | true | Refer to next paragraph for formats specifications |                       

**Statement values format**

*device type Statement*

Supported values: "blackberry", "iphone", "ipad", "windows_phone",
"windows_tablet", "windows_computer", "apple_computer", "android_phone", "android_tablet"

```json
{
  "type": "device",
  "value": "iphone"
}
```

*language type Statement*

Supported values: Any Alpha-2 code part of ISO 639 -- [Wikipedia Source](https://en.wikipedia.org/wiki/ISO_639-1)

```json
{
  "type": "language",
  "value": "en"
}
```

*location_country type Statement*

Supported values: Any Alpha-2 code part of ISO 3166 -- [ISO Search](https://www.iso.org/obp/ui/#search/code/)

```json
{
  "type": "location_country",
  "value": "US"
}
```

*context type Statement*

Scopes a typed GS1 destination to an audience. Only meaningful alongside a `link_type` — a
`context` statement without one is rejected with a `400`.

Supported values: `consumer`, `healthcareProfessional`, `patient`, `recycler`, `retailer`,
`supplier` (bare, or prefixed with `gs1:`)

```json
{
  "type": "context",
  "value": "patient"
}
```

---

### Retrieve filters for a QR Code

**HTTP request**

```GET /qrcode/<qrcode_id>/filters```

---

### Update a filter

Update an existing filter's statements and/or destination URL

**HTTP request**

```PUT /qrcode/<qrcode_id>/filter/<filter_id>```

**Request fields**

```json
{
  "final_url": "https://www.unitag.io/updated-page",
  "statements": [
    {
      "type": "language",
      "value": "fr"
    }
  ]
}
```

**Response**

```json
{
  "filter_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "final_url": "https://www.unitag.io/updated-page",
  "status": "updated"
}
```

---

### Delete a filter

**HTTP request**

```DELETE /qrcode/<qrcode_id>/filter/<filter_id>```

**Response**

```json
{
  "status": "deleted",
  "filter_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
}
```

---

## GS1 Digital Link

A GS1 Digital Link QR code encodes a product identifier as a web URI, so a single printed code can
be read by both a consumer's phone and a supply-chain scanner:

```
https://id.yourbrand.com/01/03512345678900/10/LOT42?17=261231
                         │  │              │  │     │
                         │  └─ GTIN        │  └─ lot └─ expiry (data attribute)
                         └─ AI 01          └─ AI 10
```

Unitag operates a **GS1-certified Conformant Resolver** (GS1 Conformant Resolver standard v1.2.0,
live certification and verification completed).

Because the identifier and the domain are both yours, the printed code is not tied to Unitag: it
carries no vendor-specific token, so pointing the domain elsewhere keeps every printed code working.

> NB: GS1 Digital Link codes are Dynamic or Dynamic Pro. Use `dynamic-pro` with a
> [registered domain](#domain-names) to serve codes from your own domain.

### Supported identifiers

**Primary keys** — the identifier that opens the path:

| AI | Identifier | AI | Identifier |
|---|---|---|---|
| `01` | GTIN | `8003` | GRAI |
| `00` | SSCC | `8004` | GIAI |
| `253` | GDTI | `8006` | ITIP |
| `255` | GCN | `8010` | CPID |
| `401` | GINC | `8017` | GSRN (provider) |
| `402` | GSIN | `8018` | GSRN (recipient) |
| `414` / `415` / `417` | GLN variants | | |

GTINs (AI `01`) are validated: 14 digits with a correct GS1 mod-10 check digit. A 13-digit value is
left-padded to 14 automatically. An invalid check digit is rejected at creation, and a malformed
GTIN in a scanned URI is answered `400` by the resolver.

**Key qualifiers** — appended to the path, always emitted in the standard order:

| AI | Qualifier |
|---|---|
| `22` | Consumer product variant (CPV) |
| `10` | Batch / lot |
| `21` | Serial |

**Data attributes** — appended as query parameters, not path segments. This includes **expiry date
(AI `17`)**, production date (`11`), best-before (`15`), net weight (`310n`), price, and the rest of
the GS1 Application Identifier set. Placing them in the query string rather than the path is what
the GS1 Digital Link standard requires — `17` is a data attribute, not a key qualifier.

Attributes outside the supported set are ignored rather than rejected.

### Build a Digital Link path

Validates identifiers and returns the canonical Digital Link path. Creates nothing.

**HTTP request**

```POST /gs1/look-up```

**Request fields**

```json
{
  "gtins": [
    {
      "primary_key": "01",
      "value": "03512345678900",
      "key_identifiers": [
        { "key": "10", "value": "LOT42" }
      ],
      "data_attributes": [
        { "key": "17", "value": "261231" }
      ]
    }
  ]
}
```

**Response**

```json
{
  "GS1ShortURL": [
    {
      "primary_key": "01",
      "short_url": "/01/03512345678900/10/LOT42?17=261231"
    }
  ]
}
```

Key qualifiers are emitted in the order `22 → 10 → 21` regardless of the order you supply them in.

---

### Create a GS1 Digital Link QR code

**HTTP request**

```POST /qrcode/serial```

**Request fields**

Supply either a `short_url` containing `/01/`, or the `gs1` object. When both are present the
`short_url` wins and is parsed as the canonical source.

```json
{
  "data": {
    "type": "url",
    "resolution": "dynamic-pro",
    "domain_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "url": "https://brand.example/products/welcome",
    "gs1": {
      "gtin": "03512345678900",
      "batch": "LOT42",
      "cpv": "",
      "serial": ""
    }
  },
  "settings": {
    "redundancy": "M"
  }
}
```

**Details**

*data.gs1* object:

| field  | type   | mandatory | description                                   |
|--------|--------|-----------|-----------------------------------------------|
| gtin   | string | true      | 14-digit GTIN with a valid mod-10 check digit |
| cpv    | string | false     | Consumer product variant (AI 22)              |
| batch  | string | false     | Batch / lot (AI 10)                           |
| serial | string | false     | Serial (AI 21)                                |

To include **data attributes** (expiry, weights, …), pass a full path in `data.short_url` instead —
build it with [`/gs1/look-up`](#build-a-digital-link-path):

```json
{
  "data": {
    "type": "url",
    "resolution": "dynamic-pro",
    "domain_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "url": "https://brand.example/products/welcome",
    "short_url": "/01/03512345678900/10/LOT42?17=261231"
  }
}
```

**Notes**

* The GS1 identifier path is **immutable** once created. The destination (`data.url`) and the
  filters stay editable — that is what lets you repoint a printed code without reprinting it.
* Each distinct Digital Link path is its own QR code. A GTIN, a GTIN+lot and a GTIN+serial are three
  separate codes with their own destinations and their own rules.
* Creating a code for a path that already exists returns `406`.

---

### Typed destinations (link types)

A GS1 Digital Link code can expose several destinations at once, each labelled with a
[GS1 Web Vocabulary](https://ref.gs1.org/voc/) link type — a product page, a Digital Product
Passport, safety information, a recipe — and a scanner asks for the one it wants with `?linkType=`.

Typed destinations are created through the ordinary [filter](#filters) endpoints by adding a
`link_type`:

```POST /qrcode/<qrcode_id>/filter```

```json
{
  "link_type": "dpp",
  "final_url": "https://dpp.brand.example/03512345678900/LOT42",
  "statements": []
}
```

The value is a GS1 Web Vocabulary token, bare (`dpp`) or CURIE-prefixed (`gs1:dpp`). The bare token
is what gets stored and returned. Unknown tokens are rejected with a `400`, as is any `link_type`
sent for a QR code that is not a GS1 Digital Link code.

Accepted tokens:

```
activityIdeas · allergenInfo · appDownload · backgroundInfo · brandHomepageClinical
brandHomepagePatient · careersInfo · certificationInfo · consumerHandlingStorageInfo · dpp
eifu · epcis · epil · eventsInfo · faqs · handledBy · hasRetailers · homepage · ingredientsInfo
instructions · jws · leaveReview · locationInfo · logisticsInfo · loyaltyProgram · masterData
menuInfo · nutritionalInfo · openingHoursInfo · paymentLink · pip · productSustainabilityInfo
promotion · purchaseSuppliesOrAccessories · quickStartGuide · recallStatus · recipeInfo
registerProduct · registryEntry · relatedImage · relatedVideo · reportFound · review · safetyInfo
scheduleTime · serviceInfo · smartLabel · smpc · socialMedia · statisticInfo · subscribe · support
sustainabilityInfo · traceability · tutorial · userAgreement · verificationService · whatsInTheBox
```

**Combining with conditions.** A typed destination can also carry `statements`, so the same link
type can resolve differently by country or language:

```json
{
  "link_type": "safetyInfo",
  "final_url": "https://brand.example/fr/securite",
  "statements": [
    { "type": "location_country", "value": "FR" }
  ]
}
```

Among the destinations of a requested link type, one whose statements match the scan wins;
otherwise the unconditioned destination of that type is used.

**Audience scoping.** A `context` statement narrows a destination to a GS1 audience. A destination
stating an audience is only reachable when the scan asks for it (`?context=patient`), so a context
acts as a tie-break between destinations of the same link type — it can never capture an ordinary
scan:

```json
{
  "link_type": "epil",
  "final_url": "https://brand.example/leaflet/clinical",
  "statements": [
    { "type": "context", "value": "healthcareProfessional" }
  ]
}
```

**Switching a destination off.** Set `active: false` to take a typed destination out of service
without deleting it. The resolver then falls back to the unconditioned destination of that link
type, and stops advertising the deactivated one. Omitting `active` on an update leaves it unchanged.

---

### Resolver behaviour

How a Unitag-resolved GS1 Digital Link URI answers a scan.

**Redirect (default).** A plain scan is answered `307 Temporary Redirect` to the destination, after
evaluating any country / language / device filters. Responses are marked non-cacheable so a
destination change takes effect immediately.

**Requesting a link type.**

```
GET https://id.yourbrand.com/01/03512345678900?linkType=dpp
```

`linkType` accepts the bare token, the `gs1:` CURIE, or the full vocabulary URI. `?linkType=homepage`
resolves to the code's default destination. Requesting a link type the code does not have is
answered `404` — the standard requires this rather than a silent fallback — and the response still
advertises the link types that *are* available.

**Linkset.** The full set of links for a code, as `application/linkset+json`
([RFC 9264](https://www.rfc-editor.org/rfc/rfc9264.html)):

```
GET https://id.yourbrand.com/01/03512345678900?linkType=all
GET https://id.yourbrand.com/01/03512345678900     Accept: application/linkset+json
```

```json
{
  "linkset": [
    {
      "anchor": "https://id.yourbrand.com/01/03512345678900",
      "https://ref.gs1.org/voc/defaultLink": [
        { "href": "https://brand.example/products/welcome", "title": "Homepage" }
      ],
      "https://ref.gs1.org/voc/homepage": [
        { "href": "https://brand.example/products/welcome", "title": "Homepage" }
      ],
      "https://ref.gs1.org/voc/dpp": [
        { "href": "https://dpp.brand.example/03512345678900", "title": "Digital Product Passport" }
      ]
    }
  ]
}
```

The `anchor` is your own domain. Deactivated destinations are omitted, so the linkset never
advertises a link that `?linkType=` would refuse.

**Link headers.** Redirect responses carry [RFC 8288](https://www.rfc-editor.org/rfc/rfc8288.html)
`Link` headers advertising the available typed links and the linkset:

```
Link: <https://brand.example/products/welcome>; rel="https://ref.gs1.org/voc/defaultLink"
Link: <https://dpp.brand.example/03512345678900>; rel="https://ref.gs1.org/voc/dpp"; title="Digital Product Passport"
Link: <https://id.yourbrand.com/01/03512345678900?linkType=all>; rel="linkset"; type="application/linkset+json"
```

**Discovery document.** Served on each resolver domain:

```GET https://id.yourbrand.com/.well-known/gs1resolver```

```json
{
  "name": "Unitag GS1 Digital Link Resolver",
  "resolverRoot": "https://id.yourbrand.com",
  "supportedPrimaryKeys": ["00", "01", "253", "255", "401", "402", "414", "415", "417", "8003", "8004", "8006", "8010", "8017", "8018"],
  "supportedContextValuesEnumerated": ["country", "language", "device"]
}
```

**Status codes.**

| Code | Meaning |
|---|---|
| `307` | Redirect to the resolved destination |
| `200` | Linkset returned (`application/linkset+json`) |
| `300` | Several products match the URI equally; the candidates are listed rather than guessed |
| `400` | Malformed Digital Link URI — e.g. a GTIN failing its mod-10 check digit |
| `404` | Unknown code, or a `linkType` this code does not have |

`HEAD` is supported and resolves like `GET` without a body.

**Not supported:** compressed GS1 Digital Link URIs (and therefore no `owl:sameAs` header).
Content negotiation covers `application/linkset+json`; other media types fall through to the
redirect.

---

## Scheduled Destination Changes

Schedule a QR code or packaging product to change its destination at a given date and time — a
campaign that goes live at midnight, a product page that switches to end-of-life information on a
known date, seasonal content.

**This is a scheduled change, not a scan-time condition.** A rule fires once, at `trigger_at`, and
rewrites the destination; every scan after that resolves to the new URL until the next rule fires.
It is not a "route to X between 09:00 and 17:00" filter — the resolver evaluates device, language
and country on each scan, but never the clock. If you need the destination to depend on the moment
of the scan itself, that is not currently supported.

Because a schedule rewrites the same field you would edit by hand, it composes with everything else:
[filters](#filters) keep applying after the swap, and on a GS1 code the Digital Link path is
untouched.

### Base URL

Schedules are served by a dedicated host rather than the main REST API:

| Environment | Base URL |
|---|---|
| Production | `https://scheduler-api.unitag.io` |
| Sandbox | `https://scheduler-api.sandbox.unitag.io` |

In production the same service is also reachable at `https://api-v2.unitag.io/_b/scheduler`.

Authentication is the same `X-Unitag-ApiKey` header as the rest of this API. You may additionally
send `X-Unitag-Org-Id` to scope the request to a specific organisation; it falls back to the key's
owner for standalone accounts.

If a schedule lookup cannot be completed, these endpoints return `503` rather than `401` — a `401`
here always means the key itself was rejected, never a transient failure.

### Create a schedule

**HTTP request**

```POST /schedules```

**Request fields**

```json
{
  "target_type": "qrcode",
  "target_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "rules": [
    {
      "trigger_at": "2026-12-24T23:00:00Z",
      "destination_url": "https://brand.example/christmas",
      "position": 1
    },
    {
      "trigger_at": "2026-12-26T23:00:00Z",
      "destination_url": "https://brand.example/sales",
      "position": 2
    }
  ]
}
```

**Details**

| field       | type             | mandatory | description                                                                 |
|-------------|------------------|-----------|-----------------------------------------------------------------------------|
| target_type | string           | false     | `qrcode` (default) or `packaging_product`                                   |
| target_id   | string (uuid)    | true      | UUID of the QR code or packaging product                                    |
| qr_code_id  | string (uuid)    | false     | Legacy alias for `target_id` on `qrcode` targets                            |
| rules       | Array of Rule    | true      | Between 1 and 3 rules                                                       |

*Rule* object:

| field           | type              | mandatory | description                                            |
|-----------------|-------------------|-----------|--------------------------------------------------------|
| trigger_at      | string (RFC 3339) | true      | When the change applies. Must be in the future         |
| destination_url | string            | true      | The new destination                                     |
| position        | integer           | true      | Order of the rule, 1–3                                  |

**Constraints**

* Maximum **3 rules** per schedule
* Only **one active schedule per target** at a time
* The target must exist and belong to your organisation, otherwise `403`
* `trigger_at` must be in the future at creation
* Destinations on **packaging product** targets must be `https://`

**Response**

```json
{
  "id": 12,
  "uuid": "b2c3d4e5-f6a7-8901-bcde-f23456789012",
  "organisation_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "target_type": "qrcode",
  "target_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "qr_code_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "status": "pending",
  "created_at": "2026-08-05T10:00:00Z",
  "updated_at": "2026-08-05T10:00:00Z",
  "rules": [
    {
      "id": 34,
      "uuid": "c3d4e5f6-a7b8-9012-cdef-345678901234",
      "trigger_at": "2026-12-24T23:00:00Z",
      "destination_url": "https://brand.example/christmas",
      "position": 1,
      "fired_at": null
    }
  ]
}
```

`status` is derived from the rules: `pending` (none fired), `active` (some fired, some pending),
`expired` (all fired). `fired_at` is `null` until a rule has been applied.

Rules are applied by a background job that runs every few seconds, so a change takes effect within
seconds of `trigger_at` rather than exactly on it.

---

### List schedules

**HTTP request**

```GET /schedules?page=1&page_size=20```

**Response**

```json
{
  "schedules": [],
  "total": 42,
  "page": 1,
  "page_size": 20
}
```

---

### Retrieve a schedule

**HTTP request**

```GET /schedules/<schedule_id>```

---

### Update a schedule

Replaces **all** rules on the schedule. Send the complete set you want, not just the changed ones.

**HTTP request**

```PUT /schedules/<schedule_id>```

**Request fields**

```json
{
  "rules": [
    {
      "trigger_at": "2026-12-25T23:00:00Z",
      "destination_url": "https://brand.example/boxing-day",
      "position": 1
    }
  ]
}
```

---

### Delete a schedule

Deletes the schedule and all its rules. Rules that have already fired are not rolled back — the
destination stays where it was last set.

**HTTP request**

```DELETE /schedules/<schedule_id>```

---

## Domain Names

Domain names allows to use your own domain name in your QR code for Dynamic Pro QR codes

> NB: Custom domain names are available from Gold subscription and upwards

### Register a domain name

Registering a domain name is the first operation in order to use your custom domain name with Unitag Resolver engine

Supported domain names examples:
* APEX (eg: example.org)
* SUBDOMAIN (eg: **qr**.example.org, **www**.example.org, **foo**.example.org)

**Request**

```POST /domains```

Example

```json
{
  "domain_name": "example.org"
}
```

*Data* object:

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| domain_name | string | true | Domain name that you want to register with us|


**Response**

```json
{
  "type": "APEX",
  "requested_domain": "example.org",
  "domain_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "fqdn": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6.qrcode.link",
  "ip": "1.2.3.4"
}
```

*Data* object:

| field | type  | description |  
| --- | --- | --- |  
| type | string | Either APEX or SUBDOMAIN based on the given domain |
| requested_domain | string | The domain you have submitted |
| domain_uuid | string | The UUID of your domain |
| fqdn | string | If SUBDOMAIN - Fully Qualified Domain Name - For registration purposes |
| ip | string | If APEX - IP address - For registration purposes |

Once you have received the response from the API you need to update your domain name with your registrar

If your domain name is an APEX you will need to create an A record such as:  
```example.org A 1.2.3.4```

If your domain name is a SUBDOMAIN you will need to create a CNAME record such as:   
```foo.example.org CNAME f81d4fae-7dec-11d0-a765-00a0c91e6bf6.qrcode.link.```

> NB: If you are registering a SUBDOMAIN please make sure to add a dot (.) at the end of the CNAME entry

---

### Validate a domain name

Once your domain has been registered with us you need to update your domain with your registrar (eg: Gandi, Google, OVH). Once done you will be able to finalize the registration of your domain by validating your configuration against our API

**Request**

```GET /domains/<domain_id>/check```

**Response**

HTTP code 200

```json
{
  "domain_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
}
```

HTTP code 409

```json
{
  "message": "The current entry does not resolves to a Unitag domain name, please make sure your DNS zone is correctly configured"
}
```

---

### List all domain names available

Retrieve the list of domain available for the account

**Request**

```GET /domains```

**Response**

HTTP code 200

NB: As an owner of a domain name more fields might be added if you have shared the domain across accounts

```json
[
  {
    "domain_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "domain_name": "example.org",
    "ssl_activated": true,
    "activated": true,
    "status": ""
  }  
]
```

*Data* []object:

| field         | type  | description                    |  
|---------------| --- |--------------------------------|  
| domain_id     | string | The ID of the domain           |
| domain_name   | string | The domain name as string      |
| ssl_activated | boolean | Status of the SSL service      |
| activated     | boolean | Status of the domain name      |
| status        | string | Used for deactivation purposes |

---

### Retrieve a domain name

Retrieve a single domain and the DNS entry it expects

**Request**

```GET /domains/<domain_id>```

**Response**

```json
{
  "domain_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "domain_name": "qr.example.org",
  "dns_entry_type": "CNAME",
  "dns_entry": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6.qrcode.link"
}
```

*Data* object:

| field | type | description |
| --- | --- | --- |
| domain_uuid | string | The ID of the domain |
| domain_name | string | The domain name as string |
| dns_entry_type | string | Always CNAME |
| dns_entry | string | The value to point the record at |

> NB: This endpoint always reports a CNAME. If your domain is an APEX it needs A
> records instead — use [Retrieve a domain's DNS configuration](#retrieve-a-domains-dns-configuration).

---

### Retrieve a domain's DNS configuration

Retrieve every DNS record your domain expects, together with its live status

**Request**

```GET /domains/<domain_id>/config```

**Response**

```json
{
  "domain_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "domain_name": "example.org",
  "domain_type": "APEX",
  "record_type": "A",
  "records": ["1.2.3.4", "5.6.7.8"],
  "registrar_family": "gandi",
  "status": "OK",
  "activated": true,
  "ssl_activated": true
}
```

*Data* object:

| field | type | description |
| --- | --- | --- |
| domain_id | string | The ID of the domain |
| domain_name | string | The domain name as string |
| domain_type | string | Either APEX or SUBDOMAIN |
| record_type | string | A for an APEX domain, CNAME for a subdomain |
| records | []string | Create one record_type record per value. Empty until the domain is configured |
| registrar_family | string | Detected registrar, used to pick a setup guide. `unknown` when it could not be determined |
| status | string | Result of the live DNS check. `UNKNOWN` when the check is unavailable — the records are still correct |
| activated | boolean | Status of the domain name |
| ssl_activated | boolean | Status of the SSL service |

An APEX domain returns one A record per region you have enabled, and every one
of them must exist in your DNS zone:

```example.org A 1.2.3.4```  
```example.org A 5.6.7.8```

---

### Set a domain's kind and region

Set whether the domain is an APEX or a subdomain, and which region should serve it

**Request**

```PUT /domains/<domain_id>/config```

```json
{
  "type": "SUBDOMAIN",
  "region": "eu"
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| type | string | true | APEX or SUBDOMAIN |
| region | string | true | eu, na, or all to serve from every region |

Both values are matched case-insensitively.

**Response**

```json
{
  "domain_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "type": "SUBDOMAIN",
  "region": "eu",
  "cdn_regions": ["eu"]
}
```

*Data* object:

| field | type | description |
| --- | --- | --- |
| domain_id | string | The ID of the domain |
| type | string | The kind that was persisted |
| region | string | The region that was persisted |
| cdn_regions | []string | The regions the domain is actually served from. `all` expands to every region |

> NB: Changing either value changes the DNS records the domain expects. Read the
> configuration again afterwards and update your registrar to match.

---

### Share a domain name

Share a domain with other accounts or organisations

**Request**

```PUT /domains/<domain_id>```

```json
{
  "users_ids": [],
  "orgs_ids": ["f81d4fae-7dec-11d0-a765-00a0c91e6bf6"],
  "is_shared_with_orgs": true
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| users_ids | []string | false | Accounts the domain is shared with |
| orgs_ids | []string | false | Organisations the domain is shared with |
| is_shared_with_orgs | boolean | false | Whether the domain is shared at organisation level |

> NB: Both lists are absolute. Whatever you send becomes the new set, so an
> omitted or empty array clears the sharing rather than leaving it untouched.

---

### Delete a domain name

**Request**

```DELETE /domains/<domain_id>```

**Response**

HTTP code 200

> NB: QR Codes pointing at this domain keep their short URL but stop resolving on
> it. Remember to remove the DNS records from your registrar as well.

---

## Campaigns

The campaigns endpoint allows you to work around the campaign management tool, helping you to sort your QR codes.

### List campaigns

Retrieve the list of created campaigns and sub-campaigns

**Request**
```GET /campaigns```

**Response**
```json
[
    {
        "uuid": "c2bd62df-3642-4a93-9754-aa68f65c6622",
        "name": "HEALTHCHECK",
        "color": "#673ab7",
        "creation_date": "2021-02-23T22:31:29.32Z",
        "sub_campaigns": [
            {
                "uuid": "0f877077-ac95-4e4c-b3af-5ad4fb8c1655",
                "name": "health1",
                "color": "orange",
                "creation_date": "2021-02-23T22:31:29.32Z",
                "sub_campaigns": null
            }
        ]
    },
    {
        "uuid": "a88dc890-015f-4e93-8640-a65fd66646a6",
        "name": "CAMPAIGN 1",
        "color": "#2196f3",
        "creation_date": "2021-02-24T13:51:35.127Z",
        "sub_campaigns": null
    }
]
```

---

### Create a campaign

**Request**

```POST /qrcodes/campaign```

```json
{"name": "New Campaign", "color": "blue"}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| name | string | true | Name for the campaign |
| color | string | true | Color for the campaign (hex color or predefined: purple, red, blue, green, orange, yellow) |

**Response**

```json
{
  "uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
  "name": "New Campaign",
  "color": "blue",
  "creation_date": "2023-05-26T12:39:52.921Z"
}
```

---

### Create a sub-campaign

**Request**

```POST /qrcodes/campaign```

Pass the `uuid` of the parent campaign:

```json
{"uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc", "name": "Sub Campaign", "color": "yellow"}
```

---

### Update a campaign

**Request**

```PUT /campaigns/<campaign_id>```

```json
{"name": "Updated Campaign Name", "color": "#f44336"}
```

**Response**

```json
{
  "uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
  "name": "Updated Campaign Name",
  "color": "#f44336"
}
```

---

### Get campaign assets count

Retrieve the number of QR codes associated with a campaign

**Request**

```GET /campaigns/<campaign_id>/assets_count```

**Response**

```json
{
  "id": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
  "count": 42
}
```

---

### Delete a campaign

Deleting a campaign will also delete all sub-campaigns, if any.

**Request**

```DELETE /campaigns/<campaign_uuid>```

**Response**

```json
{"id": "fd3180e2-e5e2-45ca-a8e5-b737627132bc", "status": "deleted"}
```

---

## Analytics

The Analytics endpoint allows you to retrieve stats generated by your QR Codes

### Retrieve QR codes aggregated stats

Unitag pre aggregates data in order to offload calculations for you

**Request**

```POST /analytics/qrcodes/search```

Example

The following query reads as:
* Get all stats from 2 weeks ago to now (type: 1 relate to a relative time search )

```json
{
  "time_range": {
    "type": 1,
    "number": 2,
    "unit": "weeks"
  }
}
```

* Get all stats for an absolute date range (type 0)

```json
{
  "time_range": {
    "type": 0,
    "start_date": "2022-07-31T23:00:00.000Z",
    "end_date": "2022-09-01T23:00:00.000Z"
  }
}
```

* Get all stats for specifics qrcodes 

```json
{
    "filters": [
        {
            "field": "QR Codes",
            "operator": "",
            "value": [
                "6b8e573e-f5ca-4402-b300-3641ee9484c0",
                "b229d8bc-92f6-4d88-a9d4-6e8adc7187ef"
            ]
        }
    ],
    "time_range": {
        "type": 1,
        "number": 2,
        "unit": "weeks"
    }
}
```

*Data* object:

| field | type | mandatory | description |  
| --- | --- | --- | --- |  
| time_range.type | number | true | 0 for absolute date range, 1 for relative |
| time_range.number | number | false | Length of the relative look-back window, expressed as a count of `unit` periods — i.e. "the last N units". Paired with `unit`: `number: 2` + `unit: weeks` means the last 2 weeks (and likewise the last N days, months, etc.). Required when type is 1; not used for absolute ranges (type 0). |
| time_range.unit | string | false | Unit of the relative look-back window, paired with `number` — one of: minutes, hours, days, weeks, months. E.g. `number: 3` + `unit: months` means the last 3 months. Required when type is 1; not used for absolute ranges (type 0). |
| time_range.start_date | string | false | ISO 8601 date, required if type is 0 |
| time_range.end_date | string | false | ISO 8601 date, required if type is 0 |
| filters | array | false | Array of filter objects to narrow results |
| filters[].field | string | false | "QR Codes" to filter by specific QR code UUIDs |
| filters[].value | array | false | Array of QR code UUIDs |


**Response**
```json
{
  "histogram": [
    {
      "date": 1635984000000,
      "count": 0
    },
    {
      "date": 1637193600000,
      "count": 1
    }
  ],
  "visits_count": 1,
  "visits_count_comparison": 0,
  "unique_visitors_count": 1,
  "unique_visitors_count_comparison": 0,
  "countries_histogram": [
    {
      "country_iso": "GB",
      "count": 1
    }
  ],
  "visits_history": {
    "cursor_id": "",
    "visits": [
      {
        "date": 1637251153589,
        "label": "My QR code",
        "country_iso": "GB",
        "model": "iPhone"
      }
    ]
  }
}
```

---

### Retrieve visit records

Retrieve detailed visit records for your QR Codes

**Request**

```POST /analytics/qrcodes/search/visit-records```

Uses the same request body format as the aggregated stats endpoint above.

**Response**

```json
{
  "visits_history": {
    "cursor_id": "",
    "visits": [
      {
        "date": 1637251153589,
        "label": "My QR code",
        "country_iso": "GB",
        "city_iso": "London",
        "model": "iPhone"
      }
    ]
  }
}
```

---

### Export analytics

Export analytics data as an Excel spreadsheet

**Request**

```POST /analytics/qrcodes/export```

Uses the same request body format as the aggregated stats endpoint. Add `time_zone` to localize dates in the export.

```json
{
  "time_range": {
    "type": 1,
    "number": 4,
    "unit": "weeks"
  },
  "time_zone": "Europe/Paris"
}
```

**Response**

Binary file (Excel .xlsx spreadsheet)

---

### Retrieve vCard Pro aggregated stats

Retrieve aggregated stats for your vCard Pro assets

**Request**

```POST /analytics/vcards_pro/search```

Uses the same request body and returns the same response shape as the aggregated
stats endpoint.

```json
{
  "filters": []
}
```

> NB: This endpoint always reports the last hour. Any `time_range` you send is
> ignored — it answers "what is happening right now".

---

### Retrieve an organisation's aggregated stats

Retrieve aggregated stats scoped to a single organisation

**Request**

```POST /analytics/orgs/<org_uuid>/search```

Uses the same request body and returns the same response shape as the aggregated
stats endpoint.

```json
{
  "time_range": {
    "type": 1,
    "number": 2,
    "unit": "weeks"
  }
}
```

> NB: If your role only grants you access to your own assets, the answer is
> narrowed to those rather than refused.

---

### Retrieve one account holder's aggregated stats

Retrieve aggregated stats for the assets owned by one member of your organisation

**Request**

```POST /analytics/owners/<owner_uuid>/search```

Uses the same request body and returns the same response shape as the aggregated
stats endpoint.

---

## Business Intelligence

Organisation-wide reporting: how your estate is performing, what is driving
scans, where they come from, and how you compare with your sector.

Every endpoint below is scoped to one organisation and accepts the same optional
window:

| parameter | type | description |
| --- | --- | --- |
| from | string | Start of the window, ISO 8601. Omit for the default lookback |
| to | string | End of the window, ISO 8601 |

Every response carries `truncated`. When it is `true` your estate was too large
to analyse in full and the figures come from a subset — read them as indicative
rather than exact.

### Organisation scorecard

The headline numbers for an organisation

**Request**

```GET /analytics/bi/org/<org_uuid>/scorecard?from=2026-08-01T00:00:00Z&to=2026-09-01T00:00:00Z```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "org_name": "Example Ltd",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "total_scans": 15234,
  "unique_visitors": 9871,
  "mobile_share_pct": 92.4,
  "bot_share_pct": 3.1,
  "scans_per_qr": {
    "count": 420,
    "avg": 36.3,
    "std_deviation": 88.1,
    "min": 0,
    "max": 1904
  },
  "top_countries": [
    {"key": "FR", "doc_count": 9120},
    {"key": "BE", "doc_count": 2311}
  ]
}
```

---

### What drives your scans

For each dimension, the values that are over-represented in your traffic compared
with the wider population

**Request**

```GET /analytics/bi/org/<org_uuid>/drivers```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "dimensions": {
    "country": [
      {"key": "BE", "doc_count": 2311, "bg_count": 40122, "score": 4.7}
    ],
    "device": [
      {"key": "tablet", "doc_count": 611, "bg_count": 9033, "score": 2.2}
    ]
  }
}
```

*Bucket* object:

| field | type | description |
| --- | --- | --- |
| key | string | The value |
| doc_count | integer | Occurrences in your traffic |
| bg_count | integer | Occurrences in the background population |
| score | number | How over-represented the value is. Higher is more significant |

---

### Scans per campaign

**Request**

```GET /analytics/bi/org/<org_uuid>/campaigns```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "org_name": "Example Ltd",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "truncated": false,
  "campaigns": [
    {
      "campaign_uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
      "name": "Summer 2026",
      "qr_count": 120,
      "scans": 8801
    }
  ]
}
```

---

### One campaign's scorecard and drivers

**Request**

```GET /analytics/bi/org/<org_uuid>/campaign/<campaign_uuid>```

**Response**

```json
{
  "scorecard": { "...": "same shape as the organisation scorecard" },
  "drivers": { "...": "same shape as the drivers report" }
}
```

---

### Scans by content category, audience and language

**Request**

```GET /analytics/bi/org/<org_uuid>/content-insights```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "analyzed_qrs": 388,
  "coverage_pct": 92.4,
  "by_category": [{"key": "retail", "scans": 6120, "qr_count": 141}],
  "by_audience": [{"key": "consumer", "scans": 11021, "qr_count": 302}],
  "by_language": [{"key": "fr", "scans": 9120, "qr_count": 255}]
}
```

Only QR Codes whose content has been classified are counted. `coverage_pct` tells
you how much of your estate that is.

---

### Scans over time

**Request**

```GET /analytics/bi/org/<org_uuid>/timeline?interval=1d```

| parameter | type | description |
| --- | --- | --- |
| interval | string | Bucket size for the series. Defaults to a size chosen from the window length |

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "interval": "1d",
  "total_scans": 15234,
  "growth_pct": 12.8,
  "peak": {"timestamp": 1755993600000, "date": "2026-08-24", "scans": 1204},
  "series": [{"timestamp": 1754006400000, "date": "2026-08-01", "scans": 411}],
  "by_day_of_week": [{"weekday": "Saturday", "scans": 3120}],
  "by_hour_of_day": [{"hour": 14, "scans": 1802}]
}
```

---

### Where your scans come from

**Request**

```GET /analytics/bi/org/<org_uuid>/geo```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "total_scans": 15234,
  "distinct_countries": 18,
  "concentration_index": 0.61,
  "europe_share_pct": 88.2,
  "top_countries": [{"key": "FR", "doc_count": 9120}],
  "top_cities": [{"key": "Paris", "doc_count": 4011}]
}
```

`concentration_index` runs from 0 to 1. Close to 1 means nearly all your scans
come from a single country.

---

### Visitor behaviour

New versus returning visitors, and how much each one scans

**Request**

```GET /analytics/bi/org/<org_uuid>/visitors```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "total_scans": 15234,
  "unique_visitors": 9871,
  "repeat_scan_ratio": 1.54,
  "new_visitors": 7712,
  "returning_visitors": 2159,
  "returning_share_pct": 21.9,
  "avg_scans_per_visitor": 1.54,
  "max_scans_per_visitor": 87,
  "avg_qrs_per_visitor": 1.2,
  "sampled": false,
  "note": ""
}
```

Visitor counts are approximate on large estates. `sampled` tells you when they
were computed from a sample.

---

### Over- and under-performing QR Codes

**Request**

```GET /analytics/bi/org/<org_uuid>/outliers```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "scanned_qrs": 388,
  "mean_scans_per_qr": 36.3,
  "std_deviation": 88.1,
  "stars": [
    {
      "key": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
      "label": "Storefront poster",
      "short_url": "https://unitag.io/abc123",
      "full_url": "https://example.com/summer",
      "scans": 1904,
      "z_score": 21.2,
      "reason": "far above the estate mean"
    }
  ],
  "laggards": []
}
```

`stars` are the positive outliers and `laggards` the negative ones. `z_score` is
the distance from your estate mean in standard deviations.

---

### Bot share and traffic anomalies

**Request**

```GET /analytics/bi/org/<org_uuid>/traffic-quality```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "raw_scans": 15721,
  "human_scans": 15234,
  "bot_scans": 487,
  "bot_share_pct": 3.1,
  "unique_visitors": 9871,
  "repeat_scan_ratio": 1.54,
  "suspicious_days": [{"date": "2026-08-19", "scans": 2901, "z_score": 6.4}],
  "top_bot_qrs": [
    {"key": "https://unitag.io/abc123", "label": "Storefront poster", "scans": 412, "bot_share_pct": 41.2}
  ]
}
```

> NB: `raw_scans` counts every scan, bots included. Every other analytics endpoint
> reports human scans only, so this is the larger number.

---

### QR Codes flagged as risky

QR Codes whose traffic suggests abuse, ranked by how many scans are affected

**Request**

```GET /analytics/bi/org/<org_uuid>/risk-exposure```

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "qr_total": 420,
  "truncated": false,
  "flagged_qrs": 3,
  "exposed_scans": 1204,
  "total_exposure": 802.4,
  "items": [
    {
      "qr_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
      "label": "Storefront poster",
      "short_url": "https://unitag.io/abc123",
      "full_url": "https://example.com/summer",
      "scans": 904,
      "fraud_confidence": 74,
      "reason": "sustained traffic from a single network",
      "exposure": 668.9
    }
  ]
}
```

`exposure` weights the affected scans by `fraud_confidence`, so the list ranks by
how much of your traffic is actually at stake.

---

### Compare with your sector

**Request**

```GET /analytics/bi/org/<org_uuid>/sector-benchmark?sector=retail```

| parameter | type | description |
| --- | --- | --- |
| sector | string | Override the cohort's sector. Defaults to your organisation's own detected sector |

**Response**

```json
{
  "org_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "sector": "retail",
  "sector_source": "declared",
  "org_analyzed_qrs": 388,
  "cohort_qrs": 24011,
  "cohort_orgs": 62,
  "cohort_sampled": false,
  "min_cohort_met": true,
  "scans_per_qr": {
    "org_median": 22.0,
    "cohort_median": 18.5,
    "cohort_top_quartile": 41.0,
    "delta_vs_median_pct": 18.9,
    "delta_vs_top_quartile_pct": -46.3
  },
  "drivers": {
    "country": [{"key": "BE", "doc_count": 2311, "bg_count": 40122, "score": 4.7}]
  },
  "note": ""
}
```

> NB: When `min_cohort_met` is `false` the cohort was too small to be meaningful.
> Read the comparison as indicative only.

---

## Audit

The audit endpoints return the change history of your organisation: who changed
what, when, and from which value to which.

Listings share the same parameters:

| parameter | type | description |
| --- | --- | --- |
| from | string | Start of the window, ISO 8601 |
| to | string | End of the window, ISO 8601 |
| action | string | Restrict to a single action: create, update or delete |
| source_app | string | Restrict to events emitted by one application |
| page | integer | 1-based page number. Defaults to 1 |
| per_page | integer | Events per page. Defaults to 10 |

### List an organisation's audit events

**Request**

```GET /audit/org/<org_uuid>?from=2026-08-01T00:00:00Z&per_page=25```

**Response**

```json
{
  "total": 184,
  "page": 1,
  "per_page": 25,
  "events": [
    {
      "@timestamp": "2026-08-24T09:12:44Z",
      "action": "update",
      "entity_type": "qrcode",
      "entity_uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
      "entity_label": "Storefront poster",
      "user_uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
      "user_email": "jane@example.com",
      "org_uuid": "c2bd62df-3642-4a93-9754-aa68f65c6622",
      "org_name": "Example Ltd",
      "changes": [
        {
          "field": "full_url",
          "old_value": "https://example.com/spring",
          "new_value": "https://example.com/summer"
        }
      ]
    }
  ]
}
```

*Data* object:

| field | type | description |
| --- | --- | --- |
| total | integer | Total matching events, not the size of this page |
| page | integer | The page returned |
| per_page | integer | Events per page |
| events | []object | The events |

*Event* object:

| field | type | description |
| --- | --- | --- |
| @timestamp | string | When the change happened |
| action | string | create, update or delete |
| entity_type | string | What changed |
| entity_uuid | string | The ID of the changed entity |
| entity_label | string | Human-readable name of the entity |
| user_uuid | string | Who made the change |
| user_email | string | Email of the account that made the change |
| org_uuid | string | The organisation the change belongs to |
| org_name | string | Name of that organisation |
| changes | []object | Field-level changes. Empty for create and delete |

---

### List one user's audit events

**Request**

```GET /audit/user/<user_uuid>```

Same parameters and response shape as the organisation listing.

---

### List one entity's audit events

The change history of a single QR Code

**Request**

```GET /audit/entity/<entity_uuid>```

Same parameters and response shape as the organisation listing.

---

### Export audit events

Export an audit history as a CSV file

**Request**

```POST /audit/org/<org_uuid>/export```

The same body works against `/audit/user/<user_uuid>/export` and
`/audit/entity/<entity_uuid>/export`.

```json
{
  "from": "2026-08-01T00:00:00Z",
  "to": "2026-09-01T00:00:00Z",
  "detached": false
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| from | string | false | Start of the window, ISO 8601 |
| to | string | false | End of the window, ISO 8601 |
| action | string | false | Restrict to create, update or delete |
| source_app | string | false | Restrict to events emitted by one application |
| detached | boolean | false | Build the file in the background and email it |
| receiver_email | string | false | Where to email the file. Required when detached is true |

**Response**

The CSV file. When `detached` is `true` you get `{"message": "ok"}` instead and
the file arrives by email.

---

## Labels

Labels are free-form tags for your QR Codes. A QR Code can carry several, and
labels are shared across your organisation — a label created by one member is
visible and usable by the others.

### List labels

**Request**

```GET /labels```

**Response**

```json
[
  {
    "ID": 12,
    "uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "name": "Summer 2026",
    "color": "#2B7FFF",
    "group": {
      "ID": 3,
      "uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
      "name": "Seasons",
      "description": ""
    },
    "CreatedAt": "2026-06-01T09:00:00Z",
    "UpdatedAt": "2026-06-01T09:00:00Z"
  }
]
```

*Data* []object:

| field | type | description |
| --- | --- | --- |
| ID | integer | Internal numeric id. Address labels by uuid |
| uuid | string | The ID of the label |
| name | string | The label name |
| color | string | Hex colour |
| group | object | The group the label belongs to. Absent when ungrouped |

---

### Retrieve a label

**Request**

```GET /labels/<label_id>```

**Response**

Returns an array so the shape matches the listing. It holds at most one label.

```json
[
  {
    "ID": 12,
    "uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "name": "Summer 2026",
    "color": "#2B7FFF"
  }
]
```

---

### Create a label

**Request**

```POST /labels```

```json
{
  "name": "Summer 2026",
  "color": "#2B7FFF"
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| name | string | true | The label name |
| color | string | false | Hex colour |
| group_uuid | string | false | Group to file the label under |

**Response**

```json
{
  "labels": [
    {
      "ID": 12,
      "uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
      "name": "Summer 2026",
      "color": "#2B7FFF"
    }
  ]
}
```

---

### Update a label

**Request**

```PUT /labels/<label_id>```

```json
{
  "name": "Summer 2026 — EU",
  "color": "#F97316"
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| name | string | false | The label name |
| color | string | false | Hex colour |
| group_uuid | string | false | Send a group ID to move the label, or an empty string to ungroup it. Omit to leave the grouping alone |

**Response**

Same shape as creating a label.

---

### Count QR Codes per label

Retrieve how many QR Codes carry each label, in a single call

**Request**

```POST /labels/count```

```json
{
  "label_uuids": ["f81d4fae-7dec-11d0-a765-00a0c91e6bf6"]
}
```

**Response**

```json
{
  "counts": {
    "f81d4fae-7dec-11d0-a765-00a0c91e6bf6": 42
  }
}
```

> NB: Labels with no QR Codes are absent from `counts` rather than reported as
> zero.

---

### Delete a label

**Request**

```DELETE /labels/<label_id>```

**Response**

HTTP code 204

The label is removed from every QR Code carrying it. The QR Codes themselves are
untouched.

---

## Groups

Groups collect labels under a common name.

### List groups

**Request**

```GET /groups```

**Response**

```json
[
  {
    "ID": 3,
    "uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
    "name": "Seasons",
    "description": "One label per season",
    "labels": [
      {
        "ID": 12,
        "uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
        "name": "Summer 2026",
        "color": "#2B7FFF"
      }
    ]
  }
]
```

---

### Retrieve a group

**Request**

```GET /groups/<group_id>```

**Response**

Returns an array so the shape matches the listing. It holds at most one group.

---

### Create a group

**Request**

```POST /groups```

```json
{
  "name": "Seasons",
  "description": "One label per season"
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| name | string | true | The group name |
| description | string | false | Free-form description |

**Response**

```json
{
  "ID": 3,
  "uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
  "name": "Seasons",
  "description": "One label per season",
  "labels": []
}
```

The group is created empty. Add labels to it with
[Update a group](#update-a-group) or [Update a label](#update-a-label).

---

### Update a group

**Request**

```PUT /groups/<group_id>```

```json
{
  "name": "Seasons",
  "label_uuids": ["f81d4fae-7dec-11d0-a765-00a0c91e6bf6"]
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| name | string | false | The group name |
| description | string | false | Free-form description |
| label_uuids | []string | false | Replaces the group's membership |

> NB: An omitted or empty `label_uuids` leaves the current membership alone. To
> empty a group, clear each label's `group_uuid` instead.

---

### Delete a group

**Request**

```DELETE /groups/<group_id>```

**Response**

HTTP code 204

The labels in the group survive; they simply become ungrouped.

---

## vCards

Digital business cards, each backed by its own QR Code.

### List vCards

**Request**

```GET /vcards```

**Response**

```json
[
  {
    "vcard_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "qrcode_uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
    "qrcode_template_id": "",
    "url": "https://unitag.io/contact/jane",
    "design": "",
    "data": "",
    "activated": true,
    "deactivation_reason": ""
  }
]
```

---

### Create a vCard

**Request**

```POST /vcards```

```json
{
  "url": "https://unitag.io/contact/jane",
  "label": "Jane Doe — business card"
}
```

| field | type | mandatory | description |
| --- | --- | --- | --- |
| url | string | true | Destination the vCard resolves to |
| label | string | false | Label for the generated QR Code |
| design | object | false | Same design object as [Create a QR Code](#create-a-qr-code). Omit to use your account default |

**Response**

```json
{
  "vcard": {
    "vcard_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "qrcode_uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
    "url": "https://unitag.io/contact/jane",
    "activated": true
  },
  "qr_code": {
    "uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
    "label": "Jane Doe — business card",
    "resolution_type": "dynamic",
    "short_url": "https://unitag.io/abc123",
    "full_url": "https://unitag.io/contact/jane"
  },
  "qr_code_img_url": "https://assets.unitag.io/qrcodes/fd3180e2-e5e2-45ca-a8e5-b737627132bc.png"
}
```

> NB: Creating a vCard consumes one vCard credit. The credit is refunded if
> creation fails.

---

## Assets

Assets are the files your QR Codes and bulk imports refer to: logos, overlays,
media, documents and import spreadsheets.

### Upload an asset

Upload a file and get back the ID you reference it by

**Request**

```POST /asset/upload/<asset_type>```

Send the file as `multipart/form-data` under the field name `File`.

| path parameter | description |
| --- | --- |
| asset_type | One of logo, overlay, media, document, batch |

| parameter | type | description |
| --- | --- | --- |
| vcard | boolean | Set to true to store the file against your vCard assets |

Accepted content per type:

| asset_type | accepted content |
| --- | --- |
| logo, overlay | Image formats supported by the designer |
| media, document | Media and document formats. Removed automatically after a retention period |
| batch | .xlsx spreadsheets only |

**Response**

```json
{
  "status": "created",
  "asset_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
}
```

Use the returned `asset_id` in a QR Code design (for a logo or overlay) or in a
bulk import (for a batch).

> NB: Files are validated by their actual content, not by the Content-Type you
> declare. Uploading the same file twice returns the existing asset rather than
> creating a duplicate.

---

### Excavate a logo

Clear the area around a logo so it sits in a clean zone when placed over a QR Code

**Request**

```POST /asset/excavate```

Send the image as `multipart/form-data` under the field name `File`.

**Response**

The excavated image, in the same format you sent.

Nothing is stored. Upload the result with `POST /asset/upload/logo` if you want
to reuse it.

---

### List batch bundles

**Request**

```GET /asset/batch_bundle```

**Response**

```json
[
  {
    "ID": 8,
    "UUID": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "Name": "products-august.xlsx",
    "Type": "batch",
    "ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "CreatedAt": "2026-08-01T09:00:00Z",
    "UpdatedAt": "2026-08-01T09:00:00Z"
  }
]
```

---

### Delete a batch bundle

**Request**

```POST /asset/delete/batch_bundle```

```json
{
  "asset_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
}
```

**Response**

HTTP code 200

---

## Batches

A batch is one bulk-import run: a spreadsheet of rows turned into QR Codes.

### List batches

Retrieve the bulk-import runs for your organisation, newest first

**Request**

```GET /atlas/batches```

**Response**

```json
[
  {
    "id": 8,
    "batch_id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
    "state": "done",
    "type": "qrcode",
    "number_of_assets": 250,
    "file_uuid": "fd3180e2-e5e2-45ca-a8e5-b737627132bc",
    "started_at": "2026-08-01T09:00:00Z",
    "finished_at": "2026-08-01T09:04:12Z",
    "creator_email": "jane@example.com",
    "summary": {}
  }
]
```

*Data* []object:

| field | type | description |
| --- | --- | --- |
| id | integer | Internal numeric id |
| batch_id | string | The ID of the run |
| state | string | Where the run got to |
| type | string | What the batch creates |
| number_of_assets | integer | Rows the source file held |
| file_uuid | string | The uploaded spreadsheet this run came from |
| started_at | string | When the run started |
| finished_at | string | When it finished. Zero-valued while still running |
| creator_email | string | Who started the run |
| summary | object | Per-run counters and errors. Shape depends on type |

---

## Account

### Retrieve your account

Retrieve the account your API key belongs to

**Request**

```GET /user```

**Response**

```json
{
  "id": 42,
  "uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
  "email": "jane@example.com",
  "org": "c2bd62df-3642-4a93-9754-aa68f65c6622",
  "org_name": "Example Ltd",
  "organisation_role": "ADMIN",
  "is_root_account": true,
  "account_type": "gold",
  "renewal_date": "2027-01-01T00:00:00Z",
  "activated": true,
  "deactivation_reason": "",
  "legacy_id": 0,
  "legacy_version": ""
}
```

*Data* object:

| field | type | description |
| --- | --- | --- |
| id | integer | Internal numeric id |
| uuid | string | The ID of the account |
| email | string | Email of the account |
| org | string | The ID of the account's organisation |
| org_name | string | Name of that organisation |
| organisation_role | string | The account's role inside its organisation |
| is_root_account | boolean | Whether this is the organisation's root account |
| account_type | string | The subscribed plan |
| renewal_date | string | When the subscription renews |
| activated | boolean | Status of the account |
