
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Data Loss Prevention (DLP)
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides methods for detection, risk analysis, and de-identification of privacy-sensitive fragments in text, images, and Google Cloud Platform storage repositories.
## 
## https://cloud.google.com/dlp/docs/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "dlp"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DlpInfoTypesList_588719 = ref object of OpenApiRestCall_588450
proc url_DlpInfoTypesList_588721(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpInfoTypesList_588720(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: JString
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("quotaUser")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "quotaUser", valid_588835
  var valid_588849 = query.getOrDefault("alt")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("json"))
  if valid_588849 != nil:
    section.add "alt", valid_588849
  var valid_588850 = query.getOrDefault("oauth_token")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "oauth_token", valid_588850
  var valid_588851 = query.getOrDefault("callback")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "callback", valid_588851
  var valid_588852 = query.getOrDefault("access_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "access_token", valid_588852
  var valid_588853 = query.getOrDefault("uploadType")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "uploadType", valid_588853
  var valid_588854 = query.getOrDefault("location")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "location", valid_588854
  var valid_588855 = query.getOrDefault("key")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "key", valid_588855
  var valid_588856 = query.getOrDefault("$.xgafv")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("1"))
  if valid_588856 != nil:
    section.add "$.xgafv", valid_588856
  var valid_588857 = query.getOrDefault("languageCode")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "languageCode", valid_588857
  var valid_588858 = query.getOrDefault("prettyPrint")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "prettyPrint", valid_588858
  var valid_588859 = query.getOrDefault("filter")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "filter", valid_588859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588882: Call_DlpInfoTypesList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_588882.validator(path, query, header, formData, body)
  let scheme = call_588882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588882.url(scheme.get, call_588882.host, call_588882.base,
                         call_588882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588882, url, valid)

proc call*(call_588953: Call_DlpInfoTypesList_588719; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; location: string = ""; key: string = "";
          Xgafv: string = "1"; languageCode: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## dlpInfoTypesList
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: string
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  var query_588954 = newJObject()
  add(query_588954, "upload_protocol", newJString(uploadProtocol))
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "callback", newJString(callback))
  add(query_588954, "access_token", newJString(accessToken))
  add(query_588954, "uploadType", newJString(uploadType))
  add(query_588954, "location", newJString(location))
  add(query_588954, "key", newJString(key))
  add(query_588954, "$.xgafv", newJString(Xgafv))
  add(query_588954, "languageCode", newJString(languageCode))
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  add(query_588954, "filter", newJString(filter))
  result = call_588953.call(nil, query_588954, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_588719(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com", route: "/v2/infoTypes",
    validator: validate_DlpInfoTypesList_588720, base: "/",
    url: url_DlpInfoTypesList_588721, schemes: {Scheme.Https})
type
  Call_DlpLocationsInfoTypes_588994 = ref object of OpenApiRestCall_588450
proc url_DlpLocationsInfoTypes_588996(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpLocationsInfoTypes_588995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_589011 = path.getOrDefault("location")
  valid_589011 = validateParameter(valid_589011, JString, required = true,
                                 default = nil)
  if valid_589011 != nil:
    section.add "location", valid_589011
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589012 = query.getOrDefault("upload_protocol")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "upload_protocol", valid_589012
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("callback")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "callback", valid_589017
  var valid_589018 = query.getOrDefault("access_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "access_token", valid_589018
  var valid_589019 = query.getOrDefault("uploadType")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "uploadType", valid_589019
  var valid_589020 = query.getOrDefault("key")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "key", valid_589020
  var valid_589021 = query.getOrDefault("$.xgafv")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = newJString("1"))
  if valid_589021 != nil:
    section.add "$.xgafv", valid_589021
  var valid_589022 = query.getOrDefault("prettyPrint")
  valid_589022 = validateParameter(valid_589022, JBool, required = false,
                                 default = newJBool(true))
  if valid_589022 != nil:
    section.add "prettyPrint", valid_589022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589024: Call_DlpLocationsInfoTypes_588994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_DlpLocationsInfoTypes_588994; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpLocationsInfoTypes
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  var body_589028 = newJObject()
  add(query_589027, "upload_protocol", newJString(uploadProtocol))
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(query_589027, "callback", newJString(callback))
  add(query_589027, "access_token", newJString(accessToken))
  add(query_589027, "uploadType", newJString(uploadType))
  add(query_589027, "key", newJString(key))
  add(query_589027, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589028 = body
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  add(path_589026, "location", newJString(location))
  result = call_589025.call(path_589026, query_589027, nil, nil, body_589028)

var dlpLocationsInfoTypes* = Call_DlpLocationsInfoTypes_588994(
    name: "dlpLocationsInfoTypes", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/locations/{location}/infoTypes",
    validator: validate_DlpLocationsInfoTypes_588995, base: "/",
    url: url_DlpLocationsInfoTypes_588996, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesGet_589029 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsInspectTemplatesGet_589031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesGet_589030(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the organization and inspectTemplate to be read, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589032 = path.getOrDefault("name")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "name", valid_589032
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589033 = query.getOrDefault("upload_protocol")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "upload_protocol", valid_589033
  var valid_589034 = query.getOrDefault("fields")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "fields", valid_589034
  var valid_589035 = query.getOrDefault("quotaUser")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "quotaUser", valid_589035
  var valid_589036 = query.getOrDefault("alt")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("json"))
  if valid_589036 != nil:
    section.add "alt", valid_589036
  var valid_589037 = query.getOrDefault("oauth_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "oauth_token", valid_589037
  var valid_589038 = query.getOrDefault("callback")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "callback", valid_589038
  var valid_589039 = query.getOrDefault("access_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "access_token", valid_589039
  var valid_589040 = query.getOrDefault("uploadType")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "uploadType", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_DlpOrganizationsInspectTemplatesGet_589029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_DlpOrganizationsInspectTemplatesGet_589029;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsInspectTemplatesGet
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the organization and inspectTemplate to be read, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(query_589047, "upload_protocol", newJString(uploadProtocol))
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(path_589046, "name", newJString(name))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "callback", newJString(callback))
  add(query_589047, "access_token", newJString(accessToken))
  add(query_589047, "uploadType", newJString(uploadType))
  add(query_589047, "key", newJString(key))
  add(query_589047, "$.xgafv", newJString(Xgafv))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var dlpOrganizationsInspectTemplatesGet* = Call_DlpOrganizationsInspectTemplatesGet_589029(
    name: "dlpOrganizationsInspectTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesGet_589030, base: "/",
    url: url_DlpOrganizationsInspectTemplatesGet_589031, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesPatch_589067 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsInspectTemplatesPatch_589069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesPatch_589068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of organization and inspectTemplate to be updated, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589070 = path.getOrDefault("name")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "name", valid_589070
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589071 = query.getOrDefault("upload_protocol")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "upload_protocol", valid_589071
  var valid_589072 = query.getOrDefault("fields")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "fields", valid_589072
  var valid_589073 = query.getOrDefault("quotaUser")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "quotaUser", valid_589073
  var valid_589074 = query.getOrDefault("alt")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("json"))
  if valid_589074 != nil:
    section.add "alt", valid_589074
  var valid_589075 = query.getOrDefault("oauth_token")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "oauth_token", valid_589075
  var valid_589076 = query.getOrDefault("callback")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "callback", valid_589076
  var valid_589077 = query.getOrDefault("access_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "access_token", valid_589077
  var valid_589078 = query.getOrDefault("uploadType")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "uploadType", valid_589078
  var valid_589079 = query.getOrDefault("key")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "key", valid_589079
  var valid_589080 = query.getOrDefault("$.xgafv")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("1"))
  if valid_589080 != nil:
    section.add "$.xgafv", valid_589080
  var valid_589081 = query.getOrDefault("prettyPrint")
  valid_589081 = validateParameter(valid_589081, JBool, required = false,
                                 default = newJBool(true))
  if valid_589081 != nil:
    section.add "prettyPrint", valid_589081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589083: Call_DlpOrganizationsInspectTemplatesPatch_589067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_589083.validator(path, query, header, formData, body)
  let scheme = call_589083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589083.url(scheme.get, call_589083.host, call_589083.base,
                         call_589083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589083, url, valid)

proc call*(call_589084: Call_DlpOrganizationsInspectTemplatesPatch_589067;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsInspectTemplatesPatch
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of organization and inspectTemplate to be updated, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589085 = newJObject()
  var query_589086 = newJObject()
  var body_589087 = newJObject()
  add(query_589086, "upload_protocol", newJString(uploadProtocol))
  add(query_589086, "fields", newJString(fields))
  add(query_589086, "quotaUser", newJString(quotaUser))
  add(path_589085, "name", newJString(name))
  add(query_589086, "alt", newJString(alt))
  add(query_589086, "oauth_token", newJString(oauthToken))
  add(query_589086, "callback", newJString(callback))
  add(query_589086, "access_token", newJString(accessToken))
  add(query_589086, "uploadType", newJString(uploadType))
  add(query_589086, "key", newJString(key))
  add(query_589086, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589087 = body
  add(query_589086, "prettyPrint", newJBool(prettyPrint))
  result = call_589084.call(path_589085, query_589086, nil, nil, body_589087)

var dlpOrganizationsInspectTemplatesPatch* = Call_DlpOrganizationsInspectTemplatesPatch_589067(
    name: "dlpOrganizationsInspectTemplatesPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesPatch_589068, base: "/",
    url: url_DlpOrganizationsInspectTemplatesPatch_589069, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesDelete_589048 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsInspectTemplatesDelete_589050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesDelete_589049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the organization and inspectTemplate to be deleted, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589051 = path.getOrDefault("name")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "name", valid_589051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589052 = query.getOrDefault("upload_protocol")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "upload_protocol", valid_589052
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("quotaUser")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "quotaUser", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("callback")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "callback", valid_589057
  var valid_589058 = query.getOrDefault("access_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "access_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("$.xgafv")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("1"))
  if valid_589061 != nil:
    section.add "$.xgafv", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589063: Call_DlpOrganizationsInspectTemplatesDelete_589048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_589063.validator(path, query, header, formData, body)
  let scheme = call_589063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589063.url(scheme.get, call_589063.host, call_589063.base,
                         call_589063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589063, url, valid)

proc call*(call_589064: Call_DlpOrganizationsInspectTemplatesDelete_589048;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsInspectTemplatesDelete
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the organization and inspectTemplate to be deleted, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589065 = newJObject()
  var query_589066 = newJObject()
  add(query_589066, "upload_protocol", newJString(uploadProtocol))
  add(query_589066, "fields", newJString(fields))
  add(query_589066, "quotaUser", newJString(quotaUser))
  add(path_589065, "name", newJString(name))
  add(query_589066, "alt", newJString(alt))
  add(query_589066, "oauth_token", newJString(oauthToken))
  add(query_589066, "callback", newJString(callback))
  add(query_589066, "access_token", newJString(accessToken))
  add(query_589066, "uploadType", newJString(uploadType))
  add(query_589066, "key", newJString(key))
  add(query_589066, "$.xgafv", newJString(Xgafv))
  add(query_589066, "prettyPrint", newJBool(prettyPrint))
  result = call_589064.call(path_589065, query_589066, nil, nil, nil)

var dlpOrganizationsInspectTemplatesDelete* = Call_DlpOrganizationsInspectTemplatesDelete_589048(
    name: "dlpOrganizationsInspectTemplatesDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesDelete_589049, base: "/",
    url: url_DlpOrganizationsInspectTemplatesDelete_589050,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersActivate_589088 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersActivate_589090(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersActivate_589089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589091 = path.getOrDefault("name")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "name", valid_589091
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589092 = query.getOrDefault("upload_protocol")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "upload_protocol", valid_589092
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("oauth_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "oauth_token", valid_589096
  var valid_589097 = query.getOrDefault("callback")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "callback", valid_589097
  var valid_589098 = query.getOrDefault("access_token")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "access_token", valid_589098
  var valid_589099 = query.getOrDefault("uploadType")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "uploadType", valid_589099
  var valid_589100 = query.getOrDefault("key")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "key", valid_589100
  var valid_589101 = query.getOrDefault("$.xgafv")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("1"))
  if valid_589101 != nil:
    section.add "$.xgafv", valid_589101
  var valid_589102 = query.getOrDefault("prettyPrint")
  valid_589102 = validateParameter(valid_589102, JBool, required = false,
                                 default = newJBool(true))
  if valid_589102 != nil:
    section.add "prettyPrint", valid_589102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589104: Call_DlpProjectsJobTriggersActivate_589088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  let valid = call_589104.validator(path, query, header, formData, body)
  let scheme = call_589104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589104.url(scheme.get, call_589104.host, call_589104.base,
                         call_589104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589104, url, valid)

proc call*(call_589105: Call_DlpProjectsJobTriggersActivate_589088; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsJobTriggersActivate
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589106 = newJObject()
  var query_589107 = newJObject()
  var body_589108 = newJObject()
  add(query_589107, "upload_protocol", newJString(uploadProtocol))
  add(query_589107, "fields", newJString(fields))
  add(query_589107, "quotaUser", newJString(quotaUser))
  add(path_589106, "name", newJString(name))
  add(query_589107, "alt", newJString(alt))
  add(query_589107, "oauth_token", newJString(oauthToken))
  add(query_589107, "callback", newJString(callback))
  add(query_589107, "access_token", newJString(accessToken))
  add(query_589107, "uploadType", newJString(uploadType))
  add(query_589107, "key", newJString(key))
  add(query_589107, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589108 = body
  add(query_589107, "prettyPrint", newJBool(prettyPrint))
  result = call_589105.call(path_589106, query_589107, nil, nil, body_589108)

var dlpProjectsJobTriggersActivate* = Call_DlpProjectsJobTriggersActivate_589088(
    name: "dlpProjectsJobTriggersActivate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:activate",
    validator: validate_DlpProjectsJobTriggersActivate_589089, base: "/",
    url: url_DlpProjectsJobTriggersActivate_589090, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_589109 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDlpJobsCancel_589111(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCancel_589110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the DlpJob resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589112 = path.getOrDefault("name")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "name", valid_589112
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589113 = query.getOrDefault("upload_protocol")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "upload_protocol", valid_589113
  var valid_589114 = query.getOrDefault("fields")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "fields", valid_589114
  var valid_589115 = query.getOrDefault("quotaUser")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "quotaUser", valid_589115
  var valid_589116 = query.getOrDefault("alt")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("json"))
  if valid_589116 != nil:
    section.add "alt", valid_589116
  var valid_589117 = query.getOrDefault("oauth_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "oauth_token", valid_589117
  var valid_589118 = query.getOrDefault("callback")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "callback", valid_589118
  var valid_589119 = query.getOrDefault("access_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "access_token", valid_589119
  var valid_589120 = query.getOrDefault("uploadType")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "uploadType", valid_589120
  var valid_589121 = query.getOrDefault("key")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "key", valid_589121
  var valid_589122 = query.getOrDefault("$.xgafv")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("1"))
  if valid_589122 != nil:
    section.add "$.xgafv", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589125: Call_DlpProjectsDlpJobsCancel_589109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_589125.validator(path, query, header, formData, body)
  let scheme = call_589125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589125.url(scheme.get, call_589125.host, call_589125.base,
                         call_589125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589125, url, valid)

proc call*(call_589126: Call_DlpProjectsDlpJobsCancel_589109; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsDlpJobsCancel
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the DlpJob resource to be cancelled.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589127 = newJObject()
  var query_589128 = newJObject()
  var body_589129 = newJObject()
  add(query_589128, "upload_protocol", newJString(uploadProtocol))
  add(query_589128, "fields", newJString(fields))
  add(query_589128, "quotaUser", newJString(quotaUser))
  add(path_589127, "name", newJString(name))
  add(query_589128, "alt", newJString(alt))
  add(query_589128, "oauth_token", newJString(oauthToken))
  add(query_589128, "callback", newJString(callback))
  add(query_589128, "access_token", newJString(accessToken))
  add(query_589128, "uploadType", newJString(uploadType))
  add(query_589128, "key", newJString(key))
  add(query_589128, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589129 = body
  add(query_589128, "prettyPrint", newJBool(prettyPrint))
  result = call_589126.call(path_589127, query_589128, nil, nil, body_589129)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_589109(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_589110, base: "/",
    url: url_DlpProjectsDlpJobsCancel_589111, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_589130 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsContentDeidentify_589132(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentDeidentify_589131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589133 = path.getOrDefault("parent")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "parent", valid_589133
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589134 = query.getOrDefault("upload_protocol")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "upload_protocol", valid_589134
  var valid_589135 = query.getOrDefault("fields")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "fields", valid_589135
  var valid_589136 = query.getOrDefault("quotaUser")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "quotaUser", valid_589136
  var valid_589137 = query.getOrDefault("alt")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("json"))
  if valid_589137 != nil:
    section.add "alt", valid_589137
  var valid_589138 = query.getOrDefault("oauth_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "oauth_token", valid_589138
  var valid_589139 = query.getOrDefault("callback")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "callback", valid_589139
  var valid_589140 = query.getOrDefault("access_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "access_token", valid_589140
  var valid_589141 = query.getOrDefault("uploadType")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "uploadType", valid_589141
  var valid_589142 = query.getOrDefault("key")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "key", valid_589142
  var valid_589143 = query.getOrDefault("$.xgafv")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("1"))
  if valid_589143 != nil:
    section.add "$.xgafv", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589146: Call_DlpProjectsContentDeidentify_589130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_DlpProjectsContentDeidentify_589130; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  var body_589150 = newJObject()
  add(query_589149, "upload_protocol", newJString(uploadProtocol))
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(query_589149, "callback", newJString(callback))
  add(query_589149, "access_token", newJString(accessToken))
  add(query_589149, "uploadType", newJString(uploadType))
  add(path_589148, "parent", newJString(parent))
  add(query_589149, "key", newJString(key))
  add(query_589149, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589150 = body
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(path_589148, query_589149, nil, nil, body_589150)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_589130(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_589131, base: "/",
    url: url_DlpProjectsContentDeidentify_589132, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_589151 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsContentInspect_589153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentInspect_589152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589154 = path.getOrDefault("parent")
  valid_589154 = validateParameter(valid_589154, JString, required = true,
                                 default = nil)
  if valid_589154 != nil:
    section.add "parent", valid_589154
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589155 = query.getOrDefault("upload_protocol")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "upload_protocol", valid_589155
  var valid_589156 = query.getOrDefault("fields")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "fields", valid_589156
  var valid_589157 = query.getOrDefault("quotaUser")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "quotaUser", valid_589157
  var valid_589158 = query.getOrDefault("alt")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("json"))
  if valid_589158 != nil:
    section.add "alt", valid_589158
  var valid_589159 = query.getOrDefault("oauth_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "oauth_token", valid_589159
  var valid_589160 = query.getOrDefault("callback")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "callback", valid_589160
  var valid_589161 = query.getOrDefault("access_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "access_token", valid_589161
  var valid_589162 = query.getOrDefault("uploadType")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "uploadType", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("$.xgafv")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = newJString("1"))
  if valid_589164 != nil:
    section.add "$.xgafv", valid_589164
  var valid_589165 = query.getOrDefault("prettyPrint")
  valid_589165 = validateParameter(valid_589165, JBool, required = false,
                                 default = newJBool(true))
  if valid_589165 != nil:
    section.add "prettyPrint", valid_589165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589167: Call_DlpProjectsContentInspect_589151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  let valid = call_589167.validator(path, query, header, formData, body)
  let scheme = call_589167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589167.url(scheme.get, call_589167.host, call_589167.base,
                         call_589167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589167, url, valid)

proc call*(call_589168: Call_DlpProjectsContentInspect_589151; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589169 = newJObject()
  var query_589170 = newJObject()
  var body_589171 = newJObject()
  add(query_589170, "upload_protocol", newJString(uploadProtocol))
  add(query_589170, "fields", newJString(fields))
  add(query_589170, "quotaUser", newJString(quotaUser))
  add(query_589170, "alt", newJString(alt))
  add(query_589170, "oauth_token", newJString(oauthToken))
  add(query_589170, "callback", newJString(callback))
  add(query_589170, "access_token", newJString(accessToken))
  add(query_589170, "uploadType", newJString(uploadType))
  add(path_589169, "parent", newJString(parent))
  add(query_589170, "key", newJString(key))
  add(query_589170, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589171 = body
  add(query_589170, "prettyPrint", newJBool(prettyPrint))
  result = call_589168.call(path_589169, query_589170, nil, nil, body_589171)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_589151(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_589152, base: "/",
    url: url_DlpProjectsContentInspect_589153, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_589172 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsContentReidentify_589174(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentReidentify_589173(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589175 = path.getOrDefault("parent")
  valid_589175 = validateParameter(valid_589175, JString, required = true,
                                 default = nil)
  if valid_589175 != nil:
    section.add "parent", valid_589175
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589176 = query.getOrDefault("upload_protocol")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "upload_protocol", valid_589176
  var valid_589177 = query.getOrDefault("fields")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "fields", valid_589177
  var valid_589178 = query.getOrDefault("quotaUser")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "quotaUser", valid_589178
  var valid_589179 = query.getOrDefault("alt")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("json"))
  if valid_589179 != nil:
    section.add "alt", valid_589179
  var valid_589180 = query.getOrDefault("oauth_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "oauth_token", valid_589180
  var valid_589181 = query.getOrDefault("callback")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "callback", valid_589181
  var valid_589182 = query.getOrDefault("access_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "access_token", valid_589182
  var valid_589183 = query.getOrDefault("uploadType")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "uploadType", valid_589183
  var valid_589184 = query.getOrDefault("key")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "key", valid_589184
  var valid_589185 = query.getOrDefault("$.xgafv")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = newJString("1"))
  if valid_589185 != nil:
    section.add "$.xgafv", valid_589185
  var valid_589186 = query.getOrDefault("prettyPrint")
  valid_589186 = validateParameter(valid_589186, JBool, required = false,
                                 default = newJBool(true))
  if valid_589186 != nil:
    section.add "prettyPrint", valid_589186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589188: Call_DlpProjectsContentReidentify_589172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_589188.validator(path, query, header, formData, body)
  let scheme = call_589188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589188.url(scheme.get, call_589188.host, call_589188.base,
                         call_589188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589188, url, valid)

proc call*(call_589189: Call_DlpProjectsContentReidentify_589172; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589190 = newJObject()
  var query_589191 = newJObject()
  var body_589192 = newJObject()
  add(query_589191, "upload_protocol", newJString(uploadProtocol))
  add(query_589191, "fields", newJString(fields))
  add(query_589191, "quotaUser", newJString(quotaUser))
  add(query_589191, "alt", newJString(alt))
  add(query_589191, "oauth_token", newJString(oauthToken))
  add(query_589191, "callback", newJString(callback))
  add(query_589191, "access_token", newJString(accessToken))
  add(query_589191, "uploadType", newJString(uploadType))
  add(path_589190, "parent", newJString(parent))
  add(query_589191, "key", newJString(key))
  add(query_589191, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589192 = body
  add(query_589191, "prettyPrint", newJBool(prettyPrint))
  result = call_589189.call(path_589190, query_589191, nil, nil, body_589192)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_589172(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_589173, base: "/",
    url: url_DlpProjectsContentReidentify_589174, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesCreate_589215 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsDeidentifyTemplatesCreate_589217(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesCreate_589216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589218 = path.getOrDefault("parent")
  valid_589218 = validateParameter(valid_589218, JString, required = true,
                                 default = nil)
  if valid_589218 != nil:
    section.add "parent", valid_589218
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589219 = query.getOrDefault("upload_protocol")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "upload_protocol", valid_589219
  var valid_589220 = query.getOrDefault("fields")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "fields", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("alt")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("json"))
  if valid_589222 != nil:
    section.add "alt", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("callback")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "callback", valid_589224
  var valid_589225 = query.getOrDefault("access_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "access_token", valid_589225
  var valid_589226 = query.getOrDefault("uploadType")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "uploadType", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("$.xgafv")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("1"))
  if valid_589228 != nil:
    section.add "$.xgafv", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589231: Call_DlpOrganizationsDeidentifyTemplatesCreate_589215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_589231.validator(path, query, header, formData, body)
  let scheme = call_589231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589231.url(scheme.get, call_589231.host, call_589231.base,
                         call_589231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589231, url, valid)

proc call*(call_589232: Call_DlpOrganizationsDeidentifyTemplatesCreate_589215;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesCreate
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589233 = newJObject()
  var query_589234 = newJObject()
  var body_589235 = newJObject()
  add(query_589234, "upload_protocol", newJString(uploadProtocol))
  add(query_589234, "fields", newJString(fields))
  add(query_589234, "quotaUser", newJString(quotaUser))
  add(query_589234, "alt", newJString(alt))
  add(query_589234, "oauth_token", newJString(oauthToken))
  add(query_589234, "callback", newJString(callback))
  add(query_589234, "access_token", newJString(accessToken))
  add(query_589234, "uploadType", newJString(uploadType))
  add(path_589233, "parent", newJString(parent))
  add(query_589234, "key", newJString(key))
  add(query_589234, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589235 = body
  add(query_589234, "prettyPrint", newJBool(prettyPrint))
  result = call_589232.call(path_589233, query_589234, nil, nil, body_589235)

var dlpOrganizationsDeidentifyTemplatesCreate* = Call_DlpOrganizationsDeidentifyTemplatesCreate_589215(
    name: "dlpOrganizationsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesCreate_589216,
    base: "/", url: url_DlpOrganizationsDeidentifyTemplatesCreate_589217,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesList_589193 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsDeidentifyTemplatesList_589195(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesList_589194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589196 = path.getOrDefault("parent")
  valid_589196 = validateParameter(valid_589196, JString, required = true,
                                 default = nil)
  if valid_589196 != nil:
    section.add "parent", valid_589196
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589197 = query.getOrDefault("upload_protocol")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "upload_protocol", valid_589197
  var valid_589198 = query.getOrDefault("fields")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "fields", valid_589198
  var valid_589199 = query.getOrDefault("pageToken")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "pageToken", valid_589199
  var valid_589200 = query.getOrDefault("quotaUser")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "quotaUser", valid_589200
  var valid_589201 = query.getOrDefault("alt")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = newJString("json"))
  if valid_589201 != nil:
    section.add "alt", valid_589201
  var valid_589202 = query.getOrDefault("oauth_token")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "oauth_token", valid_589202
  var valid_589203 = query.getOrDefault("callback")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "callback", valid_589203
  var valid_589204 = query.getOrDefault("access_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "access_token", valid_589204
  var valid_589205 = query.getOrDefault("uploadType")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "uploadType", valid_589205
  var valid_589206 = query.getOrDefault("orderBy")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "orderBy", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("$.xgafv")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("1"))
  if valid_589208 != nil:
    section.add "$.xgafv", valid_589208
  var valid_589209 = query.getOrDefault("pageSize")
  valid_589209 = validateParameter(valid_589209, JInt, required = false, default = nil)
  if valid_589209 != nil:
    section.add "pageSize", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589211: Call_DlpOrganizationsDeidentifyTemplatesList_589193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_DlpOrganizationsDeidentifyTemplatesList_589193;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesList
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  add(query_589214, "upload_protocol", newJString(uploadProtocol))
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "pageToken", newJString(pageToken))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "callback", newJString(callback))
  add(query_589214, "access_token", newJString(accessToken))
  add(query_589214, "uploadType", newJString(uploadType))
  add(path_589213, "parent", newJString(parent))
  add(query_589214, "orderBy", newJString(orderBy))
  add(query_589214, "key", newJString(key))
  add(query_589214, "$.xgafv", newJString(Xgafv))
  add(query_589214, "pageSize", newJInt(pageSize))
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, nil)

var dlpOrganizationsDeidentifyTemplatesList* = Call_DlpOrganizationsDeidentifyTemplatesList_589193(
    name: "dlpOrganizationsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesList_589194, base: "/",
    url: url_DlpOrganizationsDeidentifyTemplatesList_589195,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCreate_589260 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDlpJobsCreate_589262(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCreate_589261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589263 = path.getOrDefault("parent")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "parent", valid_589263
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589264 = query.getOrDefault("upload_protocol")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "upload_protocol", valid_589264
  var valid_589265 = query.getOrDefault("fields")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "fields", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("oauth_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "oauth_token", valid_589268
  var valid_589269 = query.getOrDefault("callback")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "callback", valid_589269
  var valid_589270 = query.getOrDefault("access_token")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "access_token", valid_589270
  var valid_589271 = query.getOrDefault("uploadType")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "uploadType", valid_589271
  var valid_589272 = query.getOrDefault("key")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "key", valid_589272
  var valid_589273 = query.getOrDefault("$.xgafv")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("1"))
  if valid_589273 != nil:
    section.add "$.xgafv", valid_589273
  var valid_589274 = query.getOrDefault("prettyPrint")
  valid_589274 = validateParameter(valid_589274, JBool, required = false,
                                 default = newJBool(true))
  if valid_589274 != nil:
    section.add "prettyPrint", valid_589274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589276: Call_DlpProjectsDlpJobsCreate_589260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_589276.validator(path, query, header, formData, body)
  let scheme = call_589276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589276.url(scheme.get, call_589276.host, call_589276.base,
                         call_589276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589276, url, valid)

proc call*(call_589277: Call_DlpProjectsDlpJobsCreate_589260; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsDlpJobsCreate
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589278 = newJObject()
  var query_589279 = newJObject()
  var body_589280 = newJObject()
  add(query_589279, "upload_protocol", newJString(uploadProtocol))
  add(query_589279, "fields", newJString(fields))
  add(query_589279, "quotaUser", newJString(quotaUser))
  add(query_589279, "alt", newJString(alt))
  add(query_589279, "oauth_token", newJString(oauthToken))
  add(query_589279, "callback", newJString(callback))
  add(query_589279, "access_token", newJString(accessToken))
  add(query_589279, "uploadType", newJString(uploadType))
  add(path_589278, "parent", newJString(parent))
  add(query_589279, "key", newJString(key))
  add(query_589279, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589280 = body
  add(query_589279, "prettyPrint", newJBool(prettyPrint))
  result = call_589277.call(path_589278, query_589279, nil, nil, body_589280)

var dlpProjectsDlpJobsCreate* = Call_DlpProjectsDlpJobsCreate_589260(
    name: "dlpProjectsDlpJobsCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsCreate_589261, base: "/",
    url: url_DlpProjectsDlpJobsCreate_589262, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_589236 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDlpJobsList_589238(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsList_589237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589239 = path.getOrDefault("parent")
  valid_589239 = validateParameter(valid_589239, JString, required = true,
                                 default = nil)
  if valid_589239 != nil:
    section.add "parent", valid_589239
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   type: JString
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, end_time asc, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the job was created.
  ## - `end_time`: corresponds to time the job ended.
  ## - `name`: corresponds to job's name.
  ## - `state`: corresponds to `state`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `state` - PENDING|RUNNING|CANCELED|FINISHED|FAILED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - `trigger_name` - The resource name of the trigger that created job.
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## * end_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  section = newJObject()
  var valid_589240 = query.getOrDefault("upload_protocol")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "upload_protocol", valid_589240
  var valid_589241 = query.getOrDefault("fields")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "fields", valid_589241
  var valid_589242 = query.getOrDefault("pageToken")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "pageToken", valid_589242
  var valid_589243 = query.getOrDefault("quotaUser")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "quotaUser", valid_589243
  var valid_589244 = query.getOrDefault("alt")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("json"))
  if valid_589244 != nil:
    section.add "alt", valid_589244
  var valid_589245 = query.getOrDefault("type")
  valid_589245 = validateParameter(valid_589245, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_589245 != nil:
    section.add "type", valid_589245
  var valid_589246 = query.getOrDefault("oauth_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "oauth_token", valid_589246
  var valid_589247 = query.getOrDefault("callback")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "callback", valid_589247
  var valid_589248 = query.getOrDefault("access_token")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "access_token", valid_589248
  var valid_589249 = query.getOrDefault("uploadType")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "uploadType", valid_589249
  var valid_589250 = query.getOrDefault("orderBy")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "orderBy", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("$.xgafv")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("1"))
  if valid_589252 != nil:
    section.add "$.xgafv", valid_589252
  var valid_589253 = query.getOrDefault("pageSize")
  valid_589253 = validateParameter(valid_589253, JInt, required = false, default = nil)
  if valid_589253 != nil:
    section.add "pageSize", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
  var valid_589255 = query.getOrDefault("filter")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "filter", valid_589255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589256: Call_DlpProjectsDlpJobsList_589236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_589256.validator(path, query, header, formData, body)
  let scheme = call_589256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589256.url(scheme.get, call_589256.host, call_589256.base,
                         call_589256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589256, url, valid)

proc call*(call_589257: Call_DlpProjectsDlpJobsList_589236; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json";
          `type`: string = "DLP_JOB_TYPE_UNSPECIFIED"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## dlpProjectsDlpJobsList
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   type: string
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, end_time asc, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the job was created.
  ## - `end_time`: corresponds to time the job ended.
  ## - `name`: corresponds to job's name.
  ## - `state`: corresponds to `state`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `state` - PENDING|RUNNING|CANCELED|FINISHED|FAILED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - `trigger_name` - The resource name of the trigger that created job.
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## * end_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  var path_589258 = newJObject()
  var query_589259 = newJObject()
  add(query_589259, "upload_protocol", newJString(uploadProtocol))
  add(query_589259, "fields", newJString(fields))
  add(query_589259, "pageToken", newJString(pageToken))
  add(query_589259, "quotaUser", newJString(quotaUser))
  add(query_589259, "alt", newJString(alt))
  add(query_589259, "type", newJString(`type`))
  add(query_589259, "oauth_token", newJString(oauthToken))
  add(query_589259, "callback", newJString(callback))
  add(query_589259, "access_token", newJString(accessToken))
  add(query_589259, "uploadType", newJString(uploadType))
  add(path_589258, "parent", newJString(parent))
  add(query_589259, "orderBy", newJString(orderBy))
  add(query_589259, "key", newJString(key))
  add(query_589259, "$.xgafv", newJString(Xgafv))
  add(query_589259, "pageSize", newJInt(pageSize))
  add(query_589259, "prettyPrint", newJBool(prettyPrint))
  add(query_589259, "filter", newJString(filter))
  result = call_589257.call(path_589258, query_589259, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_589236(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_589237, base: "/",
    url: url_DlpProjectsDlpJobsList_589238, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_589281 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsImageRedact_589283(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/image:redact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsImageRedact_589282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589284 = path.getOrDefault("parent")
  valid_589284 = validateParameter(valid_589284, JString, required = true,
                                 default = nil)
  if valid_589284 != nil:
    section.add "parent", valid_589284
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589285 = query.getOrDefault("upload_protocol")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "upload_protocol", valid_589285
  var valid_589286 = query.getOrDefault("fields")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "fields", valid_589286
  var valid_589287 = query.getOrDefault("quotaUser")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "quotaUser", valid_589287
  var valid_589288 = query.getOrDefault("alt")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = newJString("json"))
  if valid_589288 != nil:
    section.add "alt", valid_589288
  var valid_589289 = query.getOrDefault("oauth_token")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "oauth_token", valid_589289
  var valid_589290 = query.getOrDefault("callback")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "callback", valid_589290
  var valid_589291 = query.getOrDefault("access_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "access_token", valid_589291
  var valid_589292 = query.getOrDefault("uploadType")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "uploadType", valid_589292
  var valid_589293 = query.getOrDefault("key")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "key", valid_589293
  var valid_589294 = query.getOrDefault("$.xgafv")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = newJString("1"))
  if valid_589294 != nil:
    section.add "$.xgafv", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589297: Call_DlpProjectsImageRedact_589281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_589297.validator(path, query, header, formData, body)
  let scheme = call_589297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589297.url(scheme.get, call_589297.host, call_589297.base,
                         call_589297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589297, url, valid)

proc call*(call_589298: Call_DlpProjectsImageRedact_589281; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589299 = newJObject()
  var query_589300 = newJObject()
  var body_589301 = newJObject()
  add(query_589300, "upload_protocol", newJString(uploadProtocol))
  add(query_589300, "fields", newJString(fields))
  add(query_589300, "quotaUser", newJString(quotaUser))
  add(query_589300, "alt", newJString(alt))
  add(query_589300, "oauth_token", newJString(oauthToken))
  add(query_589300, "callback", newJString(callback))
  add(query_589300, "access_token", newJString(accessToken))
  add(query_589300, "uploadType", newJString(uploadType))
  add(path_589299, "parent", newJString(parent))
  add(query_589300, "key", newJString(key))
  add(query_589300, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589301 = body
  add(query_589300, "prettyPrint", newJBool(prettyPrint))
  result = call_589298.call(path_589299, query_589300, nil, nil, body_589301)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_589281(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_589282, base: "/",
    url: url_DlpProjectsImageRedact_589283, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesCreate_589324 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsInspectTemplatesCreate_589326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesCreate_589325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589327 = path.getOrDefault("parent")
  valid_589327 = validateParameter(valid_589327, JString, required = true,
                                 default = nil)
  if valid_589327 != nil:
    section.add "parent", valid_589327
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589328 = query.getOrDefault("upload_protocol")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "upload_protocol", valid_589328
  var valid_589329 = query.getOrDefault("fields")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "fields", valid_589329
  var valid_589330 = query.getOrDefault("quotaUser")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "quotaUser", valid_589330
  var valid_589331 = query.getOrDefault("alt")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = newJString("json"))
  if valid_589331 != nil:
    section.add "alt", valid_589331
  var valid_589332 = query.getOrDefault("oauth_token")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "oauth_token", valid_589332
  var valid_589333 = query.getOrDefault("callback")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "callback", valid_589333
  var valid_589334 = query.getOrDefault("access_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "access_token", valid_589334
  var valid_589335 = query.getOrDefault("uploadType")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "uploadType", valid_589335
  var valid_589336 = query.getOrDefault("key")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "key", valid_589336
  var valid_589337 = query.getOrDefault("$.xgafv")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = newJString("1"))
  if valid_589337 != nil:
    section.add "$.xgafv", valid_589337
  var valid_589338 = query.getOrDefault("prettyPrint")
  valid_589338 = validateParameter(valid_589338, JBool, required = false,
                                 default = newJBool(true))
  if valid_589338 != nil:
    section.add "prettyPrint", valid_589338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589340: Call_DlpOrganizationsInspectTemplatesCreate_589324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_589340.validator(path, query, header, formData, body)
  let scheme = call_589340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589340.url(scheme.get, call_589340.host, call_589340.base,
                         call_589340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589340, url, valid)

proc call*(call_589341: Call_DlpOrganizationsInspectTemplatesCreate_589324;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsInspectTemplatesCreate
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589342 = newJObject()
  var query_589343 = newJObject()
  var body_589344 = newJObject()
  add(query_589343, "upload_protocol", newJString(uploadProtocol))
  add(query_589343, "fields", newJString(fields))
  add(query_589343, "quotaUser", newJString(quotaUser))
  add(query_589343, "alt", newJString(alt))
  add(query_589343, "oauth_token", newJString(oauthToken))
  add(query_589343, "callback", newJString(callback))
  add(query_589343, "access_token", newJString(accessToken))
  add(query_589343, "uploadType", newJString(uploadType))
  add(path_589342, "parent", newJString(parent))
  add(query_589343, "key", newJString(key))
  add(query_589343, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589344 = body
  add(query_589343, "prettyPrint", newJBool(prettyPrint))
  result = call_589341.call(path_589342, query_589343, nil, nil, body_589344)

var dlpOrganizationsInspectTemplatesCreate* = Call_DlpOrganizationsInspectTemplatesCreate_589324(
    name: "dlpOrganizationsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesCreate_589325, base: "/",
    url: url_DlpOrganizationsInspectTemplatesCreate_589326,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesList_589302 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsInspectTemplatesList_589304(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesList_589303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589305 = path.getOrDefault("parent")
  valid_589305 = validateParameter(valid_589305, JString, required = true,
                                 default = nil)
  if valid_589305 != nil:
    section.add "parent", valid_589305
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589306 = query.getOrDefault("upload_protocol")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "upload_protocol", valid_589306
  var valid_589307 = query.getOrDefault("fields")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "fields", valid_589307
  var valid_589308 = query.getOrDefault("pageToken")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "pageToken", valid_589308
  var valid_589309 = query.getOrDefault("quotaUser")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "quotaUser", valid_589309
  var valid_589310 = query.getOrDefault("alt")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = newJString("json"))
  if valid_589310 != nil:
    section.add "alt", valid_589310
  var valid_589311 = query.getOrDefault("oauth_token")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "oauth_token", valid_589311
  var valid_589312 = query.getOrDefault("callback")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "callback", valid_589312
  var valid_589313 = query.getOrDefault("access_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "access_token", valid_589313
  var valid_589314 = query.getOrDefault("uploadType")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "uploadType", valid_589314
  var valid_589315 = query.getOrDefault("orderBy")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "orderBy", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("$.xgafv")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("1"))
  if valid_589317 != nil:
    section.add "$.xgafv", valid_589317
  var valid_589318 = query.getOrDefault("pageSize")
  valid_589318 = validateParameter(valid_589318, JInt, required = false, default = nil)
  if valid_589318 != nil:
    section.add "pageSize", valid_589318
  var valid_589319 = query.getOrDefault("prettyPrint")
  valid_589319 = validateParameter(valid_589319, JBool, required = false,
                                 default = newJBool(true))
  if valid_589319 != nil:
    section.add "prettyPrint", valid_589319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589320: Call_DlpOrganizationsInspectTemplatesList_589302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_589320.validator(path, query, header, formData, body)
  let scheme = call_589320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589320.url(scheme.get, call_589320.host, call_589320.base,
                         call_589320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589320, url, valid)

proc call*(call_589321: Call_DlpOrganizationsInspectTemplatesList_589302;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsInspectTemplatesList
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589322 = newJObject()
  var query_589323 = newJObject()
  add(query_589323, "upload_protocol", newJString(uploadProtocol))
  add(query_589323, "fields", newJString(fields))
  add(query_589323, "pageToken", newJString(pageToken))
  add(query_589323, "quotaUser", newJString(quotaUser))
  add(query_589323, "alt", newJString(alt))
  add(query_589323, "oauth_token", newJString(oauthToken))
  add(query_589323, "callback", newJString(callback))
  add(query_589323, "access_token", newJString(accessToken))
  add(query_589323, "uploadType", newJString(uploadType))
  add(path_589322, "parent", newJString(parent))
  add(query_589323, "orderBy", newJString(orderBy))
  add(query_589323, "key", newJString(key))
  add(query_589323, "$.xgafv", newJString(Xgafv))
  add(query_589323, "pageSize", newJInt(pageSize))
  add(query_589323, "prettyPrint", newJBool(prettyPrint))
  result = call_589321.call(path_589322, query_589323, nil, nil, nil)

var dlpOrganizationsInspectTemplatesList* = Call_DlpOrganizationsInspectTemplatesList_589302(
    name: "dlpOrganizationsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesList_589303, base: "/",
    url: url_DlpOrganizationsInspectTemplatesList_589304, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_589368 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersCreate_589370(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersCreate_589369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589371 = path.getOrDefault("parent")
  valid_589371 = validateParameter(valid_589371, JString, required = true,
                                 default = nil)
  if valid_589371 != nil:
    section.add "parent", valid_589371
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589372 = query.getOrDefault("upload_protocol")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "upload_protocol", valid_589372
  var valid_589373 = query.getOrDefault("fields")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "fields", valid_589373
  var valid_589374 = query.getOrDefault("quotaUser")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "quotaUser", valid_589374
  var valid_589375 = query.getOrDefault("alt")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = newJString("json"))
  if valid_589375 != nil:
    section.add "alt", valid_589375
  var valid_589376 = query.getOrDefault("oauth_token")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "oauth_token", valid_589376
  var valid_589377 = query.getOrDefault("callback")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "callback", valid_589377
  var valid_589378 = query.getOrDefault("access_token")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "access_token", valid_589378
  var valid_589379 = query.getOrDefault("uploadType")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "uploadType", valid_589379
  var valid_589380 = query.getOrDefault("key")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "key", valid_589380
  var valid_589381 = query.getOrDefault("$.xgafv")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = newJString("1"))
  if valid_589381 != nil:
    section.add "$.xgafv", valid_589381
  var valid_589382 = query.getOrDefault("prettyPrint")
  valid_589382 = validateParameter(valid_589382, JBool, required = false,
                                 default = newJBool(true))
  if valid_589382 != nil:
    section.add "prettyPrint", valid_589382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589384: Call_DlpProjectsJobTriggersCreate_589368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_589384.validator(path, query, header, formData, body)
  let scheme = call_589384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589384.url(scheme.get, call_589384.host, call_589384.base,
                         call_589384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589384, url, valid)

proc call*(call_589385: Call_DlpProjectsJobTriggersCreate_589368; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsJobTriggersCreate
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589386 = newJObject()
  var query_589387 = newJObject()
  var body_589388 = newJObject()
  add(query_589387, "upload_protocol", newJString(uploadProtocol))
  add(query_589387, "fields", newJString(fields))
  add(query_589387, "quotaUser", newJString(quotaUser))
  add(query_589387, "alt", newJString(alt))
  add(query_589387, "oauth_token", newJString(oauthToken))
  add(query_589387, "callback", newJString(callback))
  add(query_589387, "access_token", newJString(accessToken))
  add(query_589387, "uploadType", newJString(uploadType))
  add(path_589386, "parent", newJString(parent))
  add(query_589387, "key", newJString(key))
  add(query_589387, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589388 = body
  add(query_589387, "prettyPrint", newJBool(prettyPrint))
  result = call_589385.call(path_589386, query_589387, nil, nil, body_589388)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_589368(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_589369, base: "/",
    url: url_DlpProjectsJobTriggersCreate_589370, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_589345 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersList_589347(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersList_589346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example `projects/my-project-id`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589348 = path.getOrDefault("parent")
  valid_589348 = validateParameter(valid_589348, JString, required = true,
                                 default = nil)
  if valid_589348 != nil:
    section.add "parent", valid_589348
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the JobTrigger was created.
  ## - `update_time`: corresponds to time the JobTrigger was last updated.
  ## - `last_run_time`: corresponds to the last time the JobTrigger ran.
  ## - `name`: corresponds to JobTrigger's name.
  ## - `display_name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to JobTrigger's status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `status` - HEALTHY|PAUSED|CANCELLED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - 'last_run_time` - RFC 3339 formatted timestamp, surrounded by
  ##     quotation marks. Nanoseconds are ignored.
  ##     - 'error_count' - Number of errors that have occurred while running.
  ## * The operator must be `=` or `!=` for status and inspected_storage.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND status = HEALTHY
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = PAUSED OR state = HEALTHY)
  ## * last_run_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  section = newJObject()
  var valid_589349 = query.getOrDefault("upload_protocol")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "upload_protocol", valid_589349
  var valid_589350 = query.getOrDefault("fields")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "fields", valid_589350
  var valid_589351 = query.getOrDefault("pageToken")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "pageToken", valid_589351
  var valid_589352 = query.getOrDefault("quotaUser")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "quotaUser", valid_589352
  var valid_589353 = query.getOrDefault("alt")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = newJString("json"))
  if valid_589353 != nil:
    section.add "alt", valid_589353
  var valid_589354 = query.getOrDefault("oauth_token")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "oauth_token", valid_589354
  var valid_589355 = query.getOrDefault("callback")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "callback", valid_589355
  var valid_589356 = query.getOrDefault("access_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "access_token", valid_589356
  var valid_589357 = query.getOrDefault("uploadType")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "uploadType", valid_589357
  var valid_589358 = query.getOrDefault("orderBy")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "orderBy", valid_589358
  var valid_589359 = query.getOrDefault("key")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "key", valid_589359
  var valid_589360 = query.getOrDefault("$.xgafv")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = newJString("1"))
  if valid_589360 != nil:
    section.add "$.xgafv", valid_589360
  var valid_589361 = query.getOrDefault("pageSize")
  valid_589361 = validateParameter(valid_589361, JInt, required = false, default = nil)
  if valid_589361 != nil:
    section.add "pageSize", valid_589361
  var valid_589362 = query.getOrDefault("prettyPrint")
  valid_589362 = validateParameter(valid_589362, JBool, required = false,
                                 default = newJBool(true))
  if valid_589362 != nil:
    section.add "prettyPrint", valid_589362
  var valid_589363 = query.getOrDefault("filter")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "filter", valid_589363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589364: Call_DlpProjectsJobTriggersList_589345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_589364.validator(path, query, header, formData, body)
  let scheme = call_589364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589364.url(scheme.get, call_589364.host, call_589364.base,
                         call_589364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589364, url, valid)

proc call*(call_589365: Call_DlpProjectsJobTriggersList_589345; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## dlpProjectsJobTriggersList
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example `projects/my-project-id`.
  ##   orderBy: string
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the JobTrigger was created.
  ## - `update_time`: corresponds to time the JobTrigger was last updated.
  ## - `last_run_time`: corresponds to the last time the JobTrigger ran.
  ## - `name`: corresponds to JobTrigger's name.
  ## - `display_name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to JobTrigger's status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `status` - HEALTHY|PAUSED|CANCELLED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - 'last_run_time` - RFC 3339 formatted timestamp, surrounded by
  ##     quotation marks. Nanoseconds are ignored.
  ##     - 'error_count' - Number of errors that have occurred while running.
  ## * The operator must be `=` or `!=` for status and inspected_storage.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND status = HEALTHY
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = PAUSED OR state = HEALTHY)
  ## * last_run_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  var path_589366 = newJObject()
  var query_589367 = newJObject()
  add(query_589367, "upload_protocol", newJString(uploadProtocol))
  add(query_589367, "fields", newJString(fields))
  add(query_589367, "pageToken", newJString(pageToken))
  add(query_589367, "quotaUser", newJString(quotaUser))
  add(query_589367, "alt", newJString(alt))
  add(query_589367, "oauth_token", newJString(oauthToken))
  add(query_589367, "callback", newJString(callback))
  add(query_589367, "access_token", newJString(accessToken))
  add(query_589367, "uploadType", newJString(uploadType))
  add(path_589366, "parent", newJString(parent))
  add(query_589367, "orderBy", newJString(orderBy))
  add(query_589367, "key", newJString(key))
  add(query_589367, "$.xgafv", newJString(Xgafv))
  add(query_589367, "pageSize", newJInt(pageSize))
  add(query_589367, "prettyPrint", newJBool(prettyPrint))
  add(query_589367, "filter", newJString(filter))
  result = call_589365.call(path_589366, query_589367, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_589345(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_589346, base: "/",
    url: url_DlpProjectsJobTriggersList_589347, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentDeidentify_589389 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsLocationsContentDeidentify_589391(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentDeidentify_589390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   location: JString (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589392 = path.getOrDefault("parent")
  valid_589392 = validateParameter(valid_589392, JString, required = true,
                                 default = nil)
  if valid_589392 != nil:
    section.add "parent", valid_589392
  var valid_589393 = path.getOrDefault("location")
  valid_589393 = validateParameter(valid_589393, JString, required = true,
                                 default = nil)
  if valid_589393 != nil:
    section.add "location", valid_589393
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589394 = query.getOrDefault("upload_protocol")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "upload_protocol", valid_589394
  var valid_589395 = query.getOrDefault("fields")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "fields", valid_589395
  var valid_589396 = query.getOrDefault("quotaUser")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "quotaUser", valid_589396
  var valid_589397 = query.getOrDefault("alt")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = newJString("json"))
  if valid_589397 != nil:
    section.add "alt", valid_589397
  var valid_589398 = query.getOrDefault("oauth_token")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "oauth_token", valid_589398
  var valid_589399 = query.getOrDefault("callback")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "callback", valid_589399
  var valid_589400 = query.getOrDefault("access_token")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "access_token", valid_589400
  var valid_589401 = query.getOrDefault("uploadType")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "uploadType", valid_589401
  var valid_589402 = query.getOrDefault("key")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "key", valid_589402
  var valid_589403 = query.getOrDefault("$.xgafv")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = newJString("1"))
  if valid_589403 != nil:
    section.add "$.xgafv", valid_589403
  var valid_589404 = query.getOrDefault("prettyPrint")
  valid_589404 = validateParameter(valid_589404, JBool, required = false,
                                 default = newJBool(true))
  if valid_589404 != nil:
    section.add "prettyPrint", valid_589404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589406: Call_DlpProjectsLocationsContentDeidentify_589389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_589406.validator(path, query, header, formData, body)
  let scheme = call_589406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589406.url(scheme.get, call_589406.host, call_589406.base,
                         call_589406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589406, url, valid)

proc call*(call_589407: Call_DlpProjectsLocationsContentDeidentify_589389;
          parent: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsLocationsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  var path_589408 = newJObject()
  var query_589409 = newJObject()
  var body_589410 = newJObject()
  add(query_589409, "upload_protocol", newJString(uploadProtocol))
  add(query_589409, "fields", newJString(fields))
  add(query_589409, "quotaUser", newJString(quotaUser))
  add(query_589409, "alt", newJString(alt))
  add(query_589409, "oauth_token", newJString(oauthToken))
  add(query_589409, "callback", newJString(callback))
  add(query_589409, "access_token", newJString(accessToken))
  add(query_589409, "uploadType", newJString(uploadType))
  add(path_589408, "parent", newJString(parent))
  add(query_589409, "key", newJString(key))
  add(query_589409, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589410 = body
  add(query_589409, "prettyPrint", newJBool(prettyPrint))
  add(path_589408, "location", newJString(location))
  result = call_589407.call(path_589408, query_589409, nil, nil, body_589410)

var dlpProjectsLocationsContentDeidentify* = Call_DlpProjectsLocationsContentDeidentify_589389(
    name: "dlpProjectsLocationsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:deidentify",
    validator: validate_DlpProjectsLocationsContentDeidentify_589390, base: "/",
    url: url_DlpProjectsLocationsContentDeidentify_589391, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentInspect_589411 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsLocationsContentInspect_589413(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentInspect_589412(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   location: JString (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589414 = path.getOrDefault("parent")
  valid_589414 = validateParameter(valid_589414, JString, required = true,
                                 default = nil)
  if valid_589414 != nil:
    section.add "parent", valid_589414
  var valid_589415 = path.getOrDefault("location")
  valid_589415 = validateParameter(valid_589415, JString, required = true,
                                 default = nil)
  if valid_589415 != nil:
    section.add "location", valid_589415
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589416 = query.getOrDefault("upload_protocol")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "upload_protocol", valid_589416
  var valid_589417 = query.getOrDefault("fields")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "fields", valid_589417
  var valid_589418 = query.getOrDefault("quotaUser")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "quotaUser", valid_589418
  var valid_589419 = query.getOrDefault("alt")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = newJString("json"))
  if valid_589419 != nil:
    section.add "alt", valid_589419
  var valid_589420 = query.getOrDefault("oauth_token")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "oauth_token", valid_589420
  var valid_589421 = query.getOrDefault("callback")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "callback", valid_589421
  var valid_589422 = query.getOrDefault("access_token")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "access_token", valid_589422
  var valid_589423 = query.getOrDefault("uploadType")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "uploadType", valid_589423
  var valid_589424 = query.getOrDefault("key")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "key", valid_589424
  var valid_589425 = query.getOrDefault("$.xgafv")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = newJString("1"))
  if valid_589425 != nil:
    section.add "$.xgafv", valid_589425
  var valid_589426 = query.getOrDefault("prettyPrint")
  valid_589426 = validateParameter(valid_589426, JBool, required = false,
                                 default = newJBool(true))
  if valid_589426 != nil:
    section.add "prettyPrint", valid_589426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589428: Call_DlpProjectsLocationsContentInspect_589411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  let valid = call_589428.validator(path, query, header, formData, body)
  let scheme = call_589428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589428.url(scheme.get, call_589428.host, call_589428.base,
                         call_589428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589428, url, valid)

proc call*(call_589429: Call_DlpProjectsLocationsContentInspect_589411;
          parent: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsLocationsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  var path_589430 = newJObject()
  var query_589431 = newJObject()
  var body_589432 = newJObject()
  add(query_589431, "upload_protocol", newJString(uploadProtocol))
  add(query_589431, "fields", newJString(fields))
  add(query_589431, "quotaUser", newJString(quotaUser))
  add(query_589431, "alt", newJString(alt))
  add(query_589431, "oauth_token", newJString(oauthToken))
  add(query_589431, "callback", newJString(callback))
  add(query_589431, "access_token", newJString(accessToken))
  add(query_589431, "uploadType", newJString(uploadType))
  add(path_589430, "parent", newJString(parent))
  add(query_589431, "key", newJString(key))
  add(query_589431, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589432 = body
  add(query_589431, "prettyPrint", newJBool(prettyPrint))
  add(path_589430, "location", newJString(location))
  result = call_589429.call(path_589430, query_589431, nil, nil, body_589432)

var dlpProjectsLocationsContentInspect* = Call_DlpProjectsLocationsContentInspect_589411(
    name: "dlpProjectsLocationsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:inspect",
    validator: validate_DlpProjectsLocationsContentInspect_589412, base: "/",
    url: url_DlpProjectsLocationsContentInspect_589413, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentReidentify_589433 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsLocationsContentReidentify_589435(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentReidentify_589434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  ##   location: JString (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589436 = path.getOrDefault("parent")
  valid_589436 = validateParameter(valid_589436, JString, required = true,
                                 default = nil)
  if valid_589436 != nil:
    section.add "parent", valid_589436
  var valid_589437 = path.getOrDefault("location")
  valid_589437 = validateParameter(valid_589437, JString, required = true,
                                 default = nil)
  if valid_589437 != nil:
    section.add "location", valid_589437
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589438 = query.getOrDefault("upload_protocol")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "upload_protocol", valid_589438
  var valid_589439 = query.getOrDefault("fields")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "fields", valid_589439
  var valid_589440 = query.getOrDefault("quotaUser")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "quotaUser", valid_589440
  var valid_589441 = query.getOrDefault("alt")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = newJString("json"))
  if valid_589441 != nil:
    section.add "alt", valid_589441
  var valid_589442 = query.getOrDefault("oauth_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "oauth_token", valid_589442
  var valid_589443 = query.getOrDefault("callback")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "callback", valid_589443
  var valid_589444 = query.getOrDefault("access_token")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "access_token", valid_589444
  var valid_589445 = query.getOrDefault("uploadType")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "uploadType", valid_589445
  var valid_589446 = query.getOrDefault("key")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "key", valid_589446
  var valid_589447 = query.getOrDefault("$.xgafv")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = newJString("1"))
  if valid_589447 != nil:
    section.add "$.xgafv", valid_589447
  var valid_589448 = query.getOrDefault("prettyPrint")
  valid_589448 = validateParameter(valid_589448, JBool, required = false,
                                 default = newJBool(true))
  if valid_589448 != nil:
    section.add "prettyPrint", valid_589448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589450: Call_DlpProjectsLocationsContentReidentify_589433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_589450.validator(path, query, header, formData, body)
  let scheme = call_589450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589450.url(scheme.get, call_589450.host, call_589450.base,
                         call_589450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589450, url, valid)

proc call*(call_589451: Call_DlpProjectsLocationsContentReidentify_589433;
          parent: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsLocationsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  var path_589452 = newJObject()
  var query_589453 = newJObject()
  var body_589454 = newJObject()
  add(query_589453, "upload_protocol", newJString(uploadProtocol))
  add(query_589453, "fields", newJString(fields))
  add(query_589453, "quotaUser", newJString(quotaUser))
  add(query_589453, "alt", newJString(alt))
  add(query_589453, "oauth_token", newJString(oauthToken))
  add(query_589453, "callback", newJString(callback))
  add(query_589453, "access_token", newJString(accessToken))
  add(query_589453, "uploadType", newJString(uploadType))
  add(path_589452, "parent", newJString(parent))
  add(query_589453, "key", newJString(key))
  add(query_589453, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589454 = body
  add(query_589453, "prettyPrint", newJBool(prettyPrint))
  add(path_589452, "location", newJString(location))
  result = call_589451.call(path_589452, query_589453, nil, nil, body_589454)

var dlpProjectsLocationsContentReidentify* = Call_DlpProjectsLocationsContentReidentify_589433(
    name: "dlpProjectsLocationsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:reidentify",
    validator: validate_DlpProjectsLocationsContentReidentify_589434, base: "/",
    url: url_DlpProjectsLocationsContentReidentify_589435, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesCreate_589477 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsStoredInfoTypesCreate_589479(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/storedInfoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesCreate_589478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589480 = path.getOrDefault("parent")
  valid_589480 = validateParameter(valid_589480, JString, required = true,
                                 default = nil)
  if valid_589480 != nil:
    section.add "parent", valid_589480
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589481 = query.getOrDefault("upload_protocol")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "upload_protocol", valid_589481
  var valid_589482 = query.getOrDefault("fields")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "fields", valid_589482
  var valid_589483 = query.getOrDefault("quotaUser")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "quotaUser", valid_589483
  var valid_589484 = query.getOrDefault("alt")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = newJString("json"))
  if valid_589484 != nil:
    section.add "alt", valid_589484
  var valid_589485 = query.getOrDefault("oauth_token")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "oauth_token", valid_589485
  var valid_589486 = query.getOrDefault("callback")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "callback", valid_589486
  var valid_589487 = query.getOrDefault("access_token")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "access_token", valid_589487
  var valid_589488 = query.getOrDefault("uploadType")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "uploadType", valid_589488
  var valid_589489 = query.getOrDefault("key")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "key", valid_589489
  var valid_589490 = query.getOrDefault("$.xgafv")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = newJString("1"))
  if valid_589490 != nil:
    section.add "$.xgafv", valid_589490
  var valid_589491 = query.getOrDefault("prettyPrint")
  valid_589491 = validateParameter(valid_589491, JBool, required = false,
                                 default = newJBool(true))
  if valid_589491 != nil:
    section.add "prettyPrint", valid_589491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589493: Call_DlpOrganizationsStoredInfoTypesCreate_589477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_589493.validator(path, query, header, formData, body)
  let scheme = call_589493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589493.url(scheme.get, call_589493.host, call_589493.base,
                         call_589493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589493, url, valid)

proc call*(call_589494: Call_DlpOrganizationsStoredInfoTypesCreate_589477;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsStoredInfoTypesCreate
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589495 = newJObject()
  var query_589496 = newJObject()
  var body_589497 = newJObject()
  add(query_589496, "upload_protocol", newJString(uploadProtocol))
  add(query_589496, "fields", newJString(fields))
  add(query_589496, "quotaUser", newJString(quotaUser))
  add(query_589496, "alt", newJString(alt))
  add(query_589496, "oauth_token", newJString(oauthToken))
  add(query_589496, "callback", newJString(callback))
  add(query_589496, "access_token", newJString(accessToken))
  add(query_589496, "uploadType", newJString(uploadType))
  add(path_589495, "parent", newJString(parent))
  add(query_589496, "key", newJString(key))
  add(query_589496, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589497 = body
  add(query_589496, "prettyPrint", newJBool(prettyPrint))
  result = call_589494.call(path_589495, query_589496, nil, nil, body_589497)

var dlpOrganizationsStoredInfoTypesCreate* = Call_DlpOrganizationsStoredInfoTypesCreate_589477(
    name: "dlpOrganizationsStoredInfoTypesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesCreate_589478, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesCreate_589479, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesList_589455 = ref object of OpenApiRestCall_588450
proc url_DlpOrganizationsStoredInfoTypesList_589457(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/storedInfoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesList_589456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589458 = path.getOrDefault("parent")
  valid_589458 = validateParameter(valid_589458, JString, required = true,
                                 default = nil)
  if valid_589458 != nil:
    section.add "parent", valid_589458
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, display_name, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the most recent version of the
  ## resource was created.
  ## - `state`: corresponds to the state of the resource.
  ## - `name`: corresponds to resource name.
  ## - `display_name`: corresponds to info type's display name.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589459 = query.getOrDefault("upload_protocol")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "upload_protocol", valid_589459
  var valid_589460 = query.getOrDefault("fields")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "fields", valid_589460
  var valid_589461 = query.getOrDefault("pageToken")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "pageToken", valid_589461
  var valid_589462 = query.getOrDefault("quotaUser")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "quotaUser", valid_589462
  var valid_589463 = query.getOrDefault("alt")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = newJString("json"))
  if valid_589463 != nil:
    section.add "alt", valid_589463
  var valid_589464 = query.getOrDefault("oauth_token")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "oauth_token", valid_589464
  var valid_589465 = query.getOrDefault("callback")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "callback", valid_589465
  var valid_589466 = query.getOrDefault("access_token")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "access_token", valid_589466
  var valid_589467 = query.getOrDefault("uploadType")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "uploadType", valid_589467
  var valid_589468 = query.getOrDefault("orderBy")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "orderBy", valid_589468
  var valid_589469 = query.getOrDefault("key")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "key", valid_589469
  var valid_589470 = query.getOrDefault("$.xgafv")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = newJString("1"))
  if valid_589470 != nil:
    section.add "$.xgafv", valid_589470
  var valid_589471 = query.getOrDefault("pageSize")
  valid_589471 = validateParameter(valid_589471, JInt, required = false, default = nil)
  if valid_589471 != nil:
    section.add "pageSize", valid_589471
  var valid_589472 = query.getOrDefault("prettyPrint")
  valid_589472 = validateParameter(valid_589472, JBool, required = false,
                                 default = newJBool(true))
  if valid_589472 != nil:
    section.add "prettyPrint", valid_589472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589473: Call_DlpOrganizationsStoredInfoTypesList_589455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_589473.validator(path, query, header, formData, body)
  let scheme = call_589473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589473.url(scheme.get, call_589473.host, call_589473.base,
                         call_589473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589473, url, valid)

proc call*(call_589474: Call_DlpOrganizationsStoredInfoTypesList_589455;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsStoredInfoTypesList
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, display_name, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the most recent version of the
  ## resource was created.
  ## - `state`: corresponds to the state of the resource.
  ## - `name`: corresponds to resource name.
  ## - `display_name`: corresponds to info type's display name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589475 = newJObject()
  var query_589476 = newJObject()
  add(query_589476, "upload_protocol", newJString(uploadProtocol))
  add(query_589476, "fields", newJString(fields))
  add(query_589476, "pageToken", newJString(pageToken))
  add(query_589476, "quotaUser", newJString(quotaUser))
  add(query_589476, "alt", newJString(alt))
  add(query_589476, "oauth_token", newJString(oauthToken))
  add(query_589476, "callback", newJString(callback))
  add(query_589476, "access_token", newJString(accessToken))
  add(query_589476, "uploadType", newJString(uploadType))
  add(path_589475, "parent", newJString(parent))
  add(query_589476, "orderBy", newJString(orderBy))
  add(query_589476, "key", newJString(key))
  add(query_589476, "$.xgafv", newJString(Xgafv))
  add(query_589476, "pageSize", newJInt(pageSize))
  add(query_589476, "prettyPrint", newJBool(prettyPrint))
  result = call_589474.call(path_589475, query_589476, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesList* = Call_DlpOrganizationsStoredInfoTypesList_589455(
    name: "dlpOrganizationsStoredInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesList_589456, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesList_589457, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
