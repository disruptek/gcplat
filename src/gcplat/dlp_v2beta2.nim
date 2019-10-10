
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Data Loss Prevention (DLP)
## version: v2beta2
## termsOfService: (not provided)
## license: (not provided)
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
  ## Returns sensitive information types DLP supports.
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_588850 = query.getOrDefault("pp")
  valid_588850 = validateParameter(valid_588850, JBool, required = false,
                                 default = newJBool(true))
  if valid_588850 != nil:
    section.add "pp", valid_588850
  var valid_588851 = query.getOrDefault("oauth_token")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "oauth_token", valid_588851
  var valid_588852 = query.getOrDefault("callback")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "callback", valid_588852
  var valid_588853 = query.getOrDefault("access_token")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "access_token", valid_588853
  var valid_588854 = query.getOrDefault("uploadType")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "uploadType", valid_588854
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
  var valid_588860 = query.getOrDefault("bearer_token")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "bearer_token", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_DlpInfoTypesList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns sensitive information types DLP supports.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_DlpInfoTypesList_588719; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; languageCode: string = ""; prettyPrint: bool = true;
          filter: string = ""; bearerToken: string = ""): Recallable =
  ## dlpInfoTypesList
  ## Returns sensitive information types DLP supports.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_588955 = newJObject()
  add(query_588955, "upload_protocol", newJString(uploadProtocol))
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "pp", newJBool(pp))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "callback", newJString(callback))
  add(query_588955, "access_token", newJString(accessToken))
  add(query_588955, "uploadType", newJString(uploadType))
  add(query_588955, "key", newJString(key))
  add(query_588955, "$.xgafv", newJString(Xgafv))
  add(query_588955, "languageCode", newJString(languageCode))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  add(query_588955, "filter", newJString(filter))
  add(query_588955, "bearer_token", newJString(bearerToken))
  result = call_588954.call(nil, query_588955, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_588719(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com",
    route: "/v2beta2/infoTypes", validator: validate_DlpInfoTypesList_588720,
    base: "/", url: url_DlpInfoTypesList_588721, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersGet_588995 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersGet_588997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersGet_588996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589012 = path.getOrDefault("name")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "name", valid_589012
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589013 = query.getOrDefault("upload_protocol")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "upload_protocol", valid_589013
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("pp")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "pp", valid_589017
  var valid_589018 = query.getOrDefault("oauth_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "oauth_token", valid_589018
  var valid_589019 = query.getOrDefault("callback")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "callback", valid_589019
  var valid_589020 = query.getOrDefault("access_token")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "access_token", valid_589020
  var valid_589021 = query.getOrDefault("uploadType")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "uploadType", valid_589021
  var valid_589022 = query.getOrDefault("key")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "key", valid_589022
  var valid_589023 = query.getOrDefault("$.xgafv")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("1"))
  if valid_589023 != nil:
    section.add "$.xgafv", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
  var valid_589025 = query.getOrDefault("bearer_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "bearer_token", valid_589025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589026: Call_DlpProjectsJobTriggersGet_588995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job trigger.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_DlpProjectsJobTriggersGet_588995; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersGet
  ## Gets a job trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(path_589028, "name", newJString(name))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "pp", newJBool(pp))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "key", newJString(key))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  add(query_589029, "bearer_token", newJString(bearerToken))
  result = call_589027.call(path_589028, query_589029, nil, nil, nil)

var dlpProjectsJobTriggersGet* = Call_DlpProjectsJobTriggersGet_588995(
    name: "dlpProjectsJobTriggersGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersGet_588996, base: "/",
    url: url_DlpProjectsJobTriggersGet_588997, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersPatch_589051 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersPatch_589053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersPatch_589052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589054 = path.getOrDefault("name")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "name", valid_589054
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589055 = query.getOrDefault("upload_protocol")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "upload_protocol", valid_589055
  var valid_589056 = query.getOrDefault("fields")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "fields", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("pp")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "pp", valid_589059
  var valid_589060 = query.getOrDefault("oauth_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "oauth_token", valid_589060
  var valid_589061 = query.getOrDefault("callback")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "callback", valid_589061
  var valid_589062 = query.getOrDefault("access_token")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "access_token", valid_589062
  var valid_589063 = query.getOrDefault("uploadType")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "uploadType", valid_589063
  var valid_589064 = query.getOrDefault("key")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "key", valid_589064
  var valid_589065 = query.getOrDefault("$.xgafv")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("1"))
  if valid_589065 != nil:
    section.add "$.xgafv", valid_589065
  var valid_589066 = query.getOrDefault("prettyPrint")
  valid_589066 = validateParameter(valid_589066, JBool, required = false,
                                 default = newJBool(true))
  if valid_589066 != nil:
    section.add "prettyPrint", valid_589066
  var valid_589067 = query.getOrDefault("bearer_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "bearer_token", valid_589067
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

proc call*(call_589069: Call_DlpProjectsJobTriggersPatch_589051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job trigger.
  ## 
  let valid = call_589069.validator(path, query, header, formData, body)
  let scheme = call_589069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589069.url(scheme.get, call_589069.host, call_589069.base,
                         call_589069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589069, url, valid)

proc call*(call_589070: Call_DlpProjectsJobTriggersPatch_589051; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersPatch
  ## Updates a job trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589071 = newJObject()
  var query_589072 = newJObject()
  var body_589073 = newJObject()
  add(query_589072, "upload_protocol", newJString(uploadProtocol))
  add(query_589072, "fields", newJString(fields))
  add(query_589072, "quotaUser", newJString(quotaUser))
  add(path_589071, "name", newJString(name))
  add(query_589072, "alt", newJString(alt))
  add(query_589072, "pp", newJBool(pp))
  add(query_589072, "oauth_token", newJString(oauthToken))
  add(query_589072, "callback", newJString(callback))
  add(query_589072, "access_token", newJString(accessToken))
  add(query_589072, "uploadType", newJString(uploadType))
  add(query_589072, "key", newJString(key))
  add(query_589072, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589073 = body
  add(query_589072, "prettyPrint", newJBool(prettyPrint))
  add(query_589072, "bearer_token", newJString(bearerToken))
  result = call_589070.call(path_589071, query_589072, nil, nil, body_589073)

var dlpProjectsJobTriggersPatch* = Call_DlpProjectsJobTriggersPatch_589051(
    name: "dlpProjectsJobTriggersPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersPatch_589052, base: "/",
    url: url_DlpProjectsJobTriggersPatch_589053, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersDelete_589030 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersDelete_589032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersDelete_589031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589033 = path.getOrDefault("name")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "name", valid_589033
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589034 = query.getOrDefault("upload_protocol")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "upload_protocol", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("pp")
  valid_589038 = validateParameter(valid_589038, JBool, required = false,
                                 default = newJBool(true))
  if valid_589038 != nil:
    section.add "pp", valid_589038
  var valid_589039 = query.getOrDefault("oauth_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "oauth_token", valid_589039
  var valid_589040 = query.getOrDefault("callback")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "callback", valid_589040
  var valid_589041 = query.getOrDefault("access_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "access_token", valid_589041
  var valid_589042 = query.getOrDefault("uploadType")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "uploadType", valid_589042
  var valid_589043 = query.getOrDefault("key")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "key", valid_589043
  var valid_589044 = query.getOrDefault("$.xgafv")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("1"))
  if valid_589044 != nil:
    section.add "$.xgafv", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
  var valid_589046 = query.getOrDefault("bearer_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "bearer_token", valid_589046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589047: Call_DlpProjectsJobTriggersDelete_589030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job trigger.
  ## 
  let valid = call_589047.validator(path, query, header, formData, body)
  let scheme = call_589047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589047.url(scheme.get, call_589047.host, call_589047.base,
                         call_589047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589047, url, valid)

proc call*(call_589048: Call_DlpProjectsJobTriggersDelete_589030; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersDelete
  ## Deletes a job trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589049 = newJObject()
  var query_589050 = newJObject()
  add(query_589050, "upload_protocol", newJString(uploadProtocol))
  add(query_589050, "fields", newJString(fields))
  add(query_589050, "quotaUser", newJString(quotaUser))
  add(path_589049, "name", newJString(name))
  add(query_589050, "alt", newJString(alt))
  add(query_589050, "pp", newJBool(pp))
  add(query_589050, "oauth_token", newJString(oauthToken))
  add(query_589050, "callback", newJString(callback))
  add(query_589050, "access_token", newJString(accessToken))
  add(query_589050, "uploadType", newJString(uploadType))
  add(query_589050, "key", newJString(key))
  add(query_589050, "$.xgafv", newJString(Xgafv))
  add(query_589050, "prettyPrint", newJBool(prettyPrint))
  add(query_589050, "bearer_token", newJString(bearerToken))
  result = call_589048.call(path_589049, query_589050, nil, nil, nil)

var dlpProjectsJobTriggersDelete* = Call_DlpProjectsJobTriggersDelete_589030(
    name: "dlpProjectsJobTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersDelete_589031, base: "/",
    url: url_DlpProjectsJobTriggersDelete_589032, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_589074 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDlpJobsCancel_589076(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCancel_589075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the DlpJob resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589077 = path.getOrDefault("name")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "name", valid_589077
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589078 = query.getOrDefault("upload_protocol")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "upload_protocol", valid_589078
  var valid_589079 = query.getOrDefault("fields")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "fields", valid_589079
  var valid_589080 = query.getOrDefault("quotaUser")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "quotaUser", valid_589080
  var valid_589081 = query.getOrDefault("alt")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("json"))
  if valid_589081 != nil:
    section.add "alt", valid_589081
  var valid_589082 = query.getOrDefault("pp")
  valid_589082 = validateParameter(valid_589082, JBool, required = false,
                                 default = newJBool(true))
  if valid_589082 != nil:
    section.add "pp", valid_589082
  var valid_589083 = query.getOrDefault("oauth_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "oauth_token", valid_589083
  var valid_589084 = query.getOrDefault("callback")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "callback", valid_589084
  var valid_589085 = query.getOrDefault("access_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "access_token", valid_589085
  var valid_589086 = query.getOrDefault("uploadType")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "uploadType", valid_589086
  var valid_589087 = query.getOrDefault("key")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "key", valid_589087
  var valid_589088 = query.getOrDefault("$.xgafv")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = newJString("1"))
  if valid_589088 != nil:
    section.add "$.xgafv", valid_589088
  var valid_589089 = query.getOrDefault("prettyPrint")
  valid_589089 = validateParameter(valid_589089, JBool, required = false,
                                 default = newJBool(true))
  if valid_589089 != nil:
    section.add "prettyPrint", valid_589089
  var valid_589090 = query.getOrDefault("bearer_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "bearer_token", valid_589090
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

proc call*(call_589092: Call_DlpProjectsDlpJobsCancel_589074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_DlpProjectsDlpJobsCancel_589074; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDlpJobsCancel
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589094 = newJObject()
  var query_589095 = newJObject()
  var body_589096 = newJObject()
  add(query_589095, "upload_protocol", newJString(uploadProtocol))
  add(query_589095, "fields", newJString(fields))
  add(query_589095, "quotaUser", newJString(quotaUser))
  add(path_589094, "name", newJString(name))
  add(query_589095, "alt", newJString(alt))
  add(query_589095, "pp", newJBool(pp))
  add(query_589095, "oauth_token", newJString(oauthToken))
  add(query_589095, "callback", newJString(callback))
  add(query_589095, "access_token", newJString(accessToken))
  add(query_589095, "uploadType", newJString(uploadType))
  add(query_589095, "key", newJString(key))
  add(query_589095, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589096 = body
  add(query_589095, "prettyPrint", newJBool(prettyPrint))
  add(query_589095, "bearer_token", newJString(bearerToken))
  result = call_589093.call(path_589094, query_589095, nil, nil, body_589096)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_589074(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_589075, base: "/",
    url: url_DlpProjectsDlpJobsCancel_589076, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_589097 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsContentDeidentify_589099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentDeidentify_589098(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589100 = path.getOrDefault("parent")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "parent", valid_589100
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589101 = query.getOrDefault("upload_protocol")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "upload_protocol", valid_589101
  var valid_589102 = query.getOrDefault("fields")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "fields", valid_589102
  var valid_589103 = query.getOrDefault("quotaUser")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "quotaUser", valid_589103
  var valid_589104 = query.getOrDefault("alt")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = newJString("json"))
  if valid_589104 != nil:
    section.add "alt", valid_589104
  var valid_589105 = query.getOrDefault("pp")
  valid_589105 = validateParameter(valid_589105, JBool, required = false,
                                 default = newJBool(true))
  if valid_589105 != nil:
    section.add "pp", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("callback")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "callback", valid_589107
  var valid_589108 = query.getOrDefault("access_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "access_token", valid_589108
  var valid_589109 = query.getOrDefault("uploadType")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "uploadType", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("$.xgafv")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("1"))
  if valid_589111 != nil:
    section.add "$.xgafv", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
  var valid_589113 = query.getOrDefault("bearer_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "bearer_token", valid_589113
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

proc call*(call_589115: Call_DlpProjectsContentDeidentify_589097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ## 
  let valid = call_589115.validator(path, query, header, formData, body)
  let scheme = call_589115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589115.url(scheme.get, call_589115.host, call_589115.base,
                         call_589115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589115, url, valid)

proc call*(call_589116: Call_DlpProjectsContentDeidentify_589097; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589117 = newJObject()
  var query_589118 = newJObject()
  var body_589119 = newJObject()
  add(query_589118, "upload_protocol", newJString(uploadProtocol))
  add(query_589118, "fields", newJString(fields))
  add(query_589118, "quotaUser", newJString(quotaUser))
  add(query_589118, "alt", newJString(alt))
  add(query_589118, "pp", newJBool(pp))
  add(query_589118, "oauth_token", newJString(oauthToken))
  add(query_589118, "callback", newJString(callback))
  add(query_589118, "access_token", newJString(accessToken))
  add(query_589118, "uploadType", newJString(uploadType))
  add(path_589117, "parent", newJString(parent))
  add(query_589118, "key", newJString(key))
  add(query_589118, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589119 = body
  add(query_589118, "prettyPrint", newJBool(prettyPrint))
  add(query_589118, "bearer_token", newJString(bearerToken))
  result = call_589116.call(path_589117, query_589118, nil, nil, body_589119)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_589097(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_589098, base: "/",
    url: url_DlpProjectsContentDeidentify_589099, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_589120 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsContentInspect_589122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentInspect_589121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589123 = path.getOrDefault("parent")
  valid_589123 = validateParameter(valid_589123, JString, required = true,
                                 default = nil)
  if valid_589123 != nil:
    section.add "parent", valid_589123
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589124 = query.getOrDefault("upload_protocol")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "upload_protocol", valid_589124
  var valid_589125 = query.getOrDefault("fields")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "fields", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("pp")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "pp", valid_589128
  var valid_589129 = query.getOrDefault("oauth_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "oauth_token", valid_589129
  var valid_589130 = query.getOrDefault("callback")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "callback", valid_589130
  var valid_589131 = query.getOrDefault("access_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "access_token", valid_589131
  var valid_589132 = query.getOrDefault("uploadType")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "uploadType", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("$.xgafv")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("1"))
  if valid_589134 != nil:
    section.add "$.xgafv", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
  var valid_589136 = query.getOrDefault("bearer_token")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "bearer_token", valid_589136
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

proc call*(call_589138: Call_DlpProjectsContentInspect_589120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_DlpProjectsContentInspect_589120; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  var body_589142 = newJObject()
  add(query_589141, "upload_protocol", newJString(uploadProtocol))
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(query_589141, "alt", newJString(alt))
  add(query_589141, "pp", newJBool(pp))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "callback", newJString(callback))
  add(query_589141, "access_token", newJString(accessToken))
  add(query_589141, "uploadType", newJString(uploadType))
  add(path_589140, "parent", newJString(parent))
  add(query_589141, "key", newJString(key))
  add(query_589141, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589142 = body
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  add(query_589141, "bearer_token", newJString(bearerToken))
  result = call_589139.call(path_589140, query_589141, nil, nil, body_589142)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_589120(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_589121, base: "/",
    url: url_DlpProjectsContentInspect_589122, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_589143 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsContentReidentify_589145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentReidentify_589144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identify content that has been de-identified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589146 = path.getOrDefault("parent")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "parent", valid_589146
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589147 = query.getOrDefault("upload_protocol")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "upload_protocol", valid_589147
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("quotaUser")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "quotaUser", valid_589149
  var valid_589150 = query.getOrDefault("alt")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("json"))
  if valid_589150 != nil:
    section.add "alt", valid_589150
  var valid_589151 = query.getOrDefault("pp")
  valid_589151 = validateParameter(valid_589151, JBool, required = false,
                                 default = newJBool(true))
  if valid_589151 != nil:
    section.add "pp", valid_589151
  var valid_589152 = query.getOrDefault("oauth_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "oauth_token", valid_589152
  var valid_589153 = query.getOrDefault("callback")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "callback", valid_589153
  var valid_589154 = query.getOrDefault("access_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "access_token", valid_589154
  var valid_589155 = query.getOrDefault("uploadType")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "uploadType", valid_589155
  var valid_589156 = query.getOrDefault("key")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "key", valid_589156
  var valid_589157 = query.getOrDefault("$.xgafv")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = newJString("1"))
  if valid_589157 != nil:
    section.add "$.xgafv", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
  var valid_589159 = query.getOrDefault("bearer_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "bearer_token", valid_589159
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

proc call*(call_589161: Call_DlpProjectsContentReidentify_589143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identify content that has been de-identified.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_DlpProjectsContentReidentify_589143; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsContentReidentify
  ## Re-identify content that has been de-identified.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589163 = newJObject()
  var query_589164 = newJObject()
  var body_589165 = newJObject()
  add(query_589164, "upload_protocol", newJString(uploadProtocol))
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(query_589164, "alt", newJString(alt))
  add(query_589164, "pp", newJBool(pp))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(query_589164, "callback", newJString(callback))
  add(query_589164, "access_token", newJString(accessToken))
  add(query_589164, "uploadType", newJString(uploadType))
  add(path_589163, "parent", newJString(parent))
  add(query_589164, "key", newJString(key))
  add(query_589164, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589165 = body
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  add(query_589164, "bearer_token", newJString(bearerToken))
  result = call_589162.call(path_589163, query_589164, nil, nil, body_589165)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_589143(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_589144, base: "/",
    url: url_DlpProjectsContentReidentify_589145, schemes: {Scheme.Https})
type
  Call_DlpProjectsDataSourceAnalyze_589166 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDataSourceAnalyze_589168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dataSource:analyze")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDataSourceAnalyze_589167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589169 = path.getOrDefault("parent")
  valid_589169 = validateParameter(valid_589169, JString, required = true,
                                 default = nil)
  if valid_589169 != nil:
    section.add "parent", valid_589169
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589170 = query.getOrDefault("upload_protocol")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "upload_protocol", valid_589170
  var valid_589171 = query.getOrDefault("fields")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "fields", valid_589171
  var valid_589172 = query.getOrDefault("quotaUser")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "quotaUser", valid_589172
  var valid_589173 = query.getOrDefault("alt")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("json"))
  if valid_589173 != nil:
    section.add "alt", valid_589173
  var valid_589174 = query.getOrDefault("pp")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(true))
  if valid_589174 != nil:
    section.add "pp", valid_589174
  var valid_589175 = query.getOrDefault("oauth_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "oauth_token", valid_589175
  var valid_589176 = query.getOrDefault("callback")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "callback", valid_589176
  var valid_589177 = query.getOrDefault("access_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "access_token", valid_589177
  var valid_589178 = query.getOrDefault("uploadType")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "uploadType", valid_589178
  var valid_589179 = query.getOrDefault("key")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "key", valid_589179
  var valid_589180 = query.getOrDefault("$.xgafv")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("1"))
  if valid_589180 != nil:
    section.add "$.xgafv", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
  var valid_589182 = query.getOrDefault("bearer_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "bearer_token", valid_589182
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

proc call*(call_589184: Call_DlpProjectsDataSourceAnalyze_589166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ## 
  let valid = call_589184.validator(path, query, header, formData, body)
  let scheme = call_589184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589184.url(scheme.get, call_589184.host, call_589184.base,
                         call_589184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589184, url, valid)

proc call*(call_589185: Call_DlpProjectsDataSourceAnalyze_589166; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDataSourceAnalyze
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589186 = newJObject()
  var query_589187 = newJObject()
  var body_589188 = newJObject()
  add(query_589187, "upload_protocol", newJString(uploadProtocol))
  add(query_589187, "fields", newJString(fields))
  add(query_589187, "quotaUser", newJString(quotaUser))
  add(query_589187, "alt", newJString(alt))
  add(query_589187, "pp", newJBool(pp))
  add(query_589187, "oauth_token", newJString(oauthToken))
  add(query_589187, "callback", newJString(callback))
  add(query_589187, "access_token", newJString(accessToken))
  add(query_589187, "uploadType", newJString(uploadType))
  add(path_589186, "parent", newJString(parent))
  add(query_589187, "key", newJString(key))
  add(query_589187, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589188 = body
  add(query_589187, "prettyPrint", newJBool(prettyPrint))
  add(query_589187, "bearer_token", newJString(bearerToken))
  result = call_589185.call(path_589186, query_589187, nil, nil, body_589188)

var dlpProjectsDataSourceAnalyze* = Call_DlpProjectsDataSourceAnalyze_589166(
    name: "dlpProjectsDataSourceAnalyze", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dataSource:analyze",
    validator: validate_DlpProjectsDataSourceAnalyze_589167, base: "/",
    url: url_DlpProjectsDataSourceAnalyze_589168, schemes: {Scheme.Https})
type
  Call_DlpProjectsDataSourceInspect_589189 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDataSourceInspect_589191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dataSource:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDataSourceInspect_589190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589192 = path.getOrDefault("parent")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "parent", valid_589192
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589193 = query.getOrDefault("upload_protocol")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "upload_protocol", valid_589193
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("quotaUser")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "quotaUser", valid_589195
  var valid_589196 = query.getOrDefault("alt")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = newJString("json"))
  if valid_589196 != nil:
    section.add "alt", valid_589196
  var valid_589197 = query.getOrDefault("pp")
  valid_589197 = validateParameter(valid_589197, JBool, required = false,
                                 default = newJBool(true))
  if valid_589197 != nil:
    section.add "pp", valid_589197
  var valid_589198 = query.getOrDefault("oauth_token")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "oauth_token", valid_589198
  var valid_589199 = query.getOrDefault("callback")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "callback", valid_589199
  var valid_589200 = query.getOrDefault("access_token")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "access_token", valid_589200
  var valid_589201 = query.getOrDefault("uploadType")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "uploadType", valid_589201
  var valid_589202 = query.getOrDefault("key")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "key", valid_589202
  var valid_589203 = query.getOrDefault("$.xgafv")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = newJString("1"))
  if valid_589203 != nil:
    section.add "$.xgafv", valid_589203
  var valid_589204 = query.getOrDefault("prettyPrint")
  valid_589204 = validateParameter(valid_589204, JBool, required = false,
                                 default = newJBool(true))
  if valid_589204 != nil:
    section.add "prettyPrint", valid_589204
  var valid_589205 = query.getOrDefault("bearer_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "bearer_token", valid_589205
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

proc call*(call_589207: Call_DlpProjectsDataSourceInspect_589189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ## 
  let valid = call_589207.validator(path, query, header, formData, body)
  let scheme = call_589207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589207.url(scheme.get, call_589207.host, call_589207.base,
                         call_589207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589207, url, valid)

proc call*(call_589208: Call_DlpProjectsDataSourceInspect_589189; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDataSourceInspect
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589209 = newJObject()
  var query_589210 = newJObject()
  var body_589211 = newJObject()
  add(query_589210, "upload_protocol", newJString(uploadProtocol))
  add(query_589210, "fields", newJString(fields))
  add(query_589210, "quotaUser", newJString(quotaUser))
  add(query_589210, "alt", newJString(alt))
  add(query_589210, "pp", newJBool(pp))
  add(query_589210, "oauth_token", newJString(oauthToken))
  add(query_589210, "callback", newJString(callback))
  add(query_589210, "access_token", newJString(accessToken))
  add(query_589210, "uploadType", newJString(uploadType))
  add(path_589209, "parent", newJString(parent))
  add(query_589210, "key", newJString(key))
  add(query_589210, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589211 = body
  add(query_589210, "prettyPrint", newJBool(prettyPrint))
  add(query_589210, "bearer_token", newJString(bearerToken))
  result = call_589208.call(path_589209, query_589210, nil, nil, body_589211)

var dlpProjectsDataSourceInspect* = Call_DlpProjectsDataSourceInspect_589189(
    name: "dlpProjectsDataSourceInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dataSource:inspect",
    validator: validate_DlpProjectsDataSourceInspect_589190, base: "/",
    url: url_DlpProjectsDataSourceInspect_589191, schemes: {Scheme.Https})
type
  Call_DlpProjectsDeidentifyTemplatesCreate_589235 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDeidentifyTemplatesCreate_589237(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDeidentifyTemplatesCreate_589236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589238 = path.getOrDefault("parent")
  valid_589238 = validateParameter(valid_589238, JString, required = true,
                                 default = nil)
  if valid_589238 != nil:
    section.add "parent", valid_589238
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589239 = query.getOrDefault("upload_protocol")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "upload_protocol", valid_589239
  var valid_589240 = query.getOrDefault("fields")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "fields", valid_589240
  var valid_589241 = query.getOrDefault("quotaUser")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "quotaUser", valid_589241
  var valid_589242 = query.getOrDefault("alt")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = newJString("json"))
  if valid_589242 != nil:
    section.add "alt", valid_589242
  var valid_589243 = query.getOrDefault("pp")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "pp", valid_589243
  var valid_589244 = query.getOrDefault("oauth_token")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "oauth_token", valid_589244
  var valid_589245 = query.getOrDefault("callback")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "callback", valid_589245
  var valid_589246 = query.getOrDefault("access_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "access_token", valid_589246
  var valid_589247 = query.getOrDefault("uploadType")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "uploadType", valid_589247
  var valid_589248 = query.getOrDefault("key")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "key", valid_589248
  var valid_589249 = query.getOrDefault("$.xgafv")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = newJString("1"))
  if valid_589249 != nil:
    section.add "$.xgafv", valid_589249
  var valid_589250 = query.getOrDefault("prettyPrint")
  valid_589250 = validateParameter(valid_589250, JBool, required = false,
                                 default = newJBool(true))
  if valid_589250 != nil:
    section.add "prettyPrint", valid_589250
  var valid_589251 = query.getOrDefault("bearer_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "bearer_token", valid_589251
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

proc call*(call_589253: Call_DlpProjectsDeidentifyTemplatesCreate_589235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ## 
  let valid = call_589253.validator(path, query, header, formData, body)
  let scheme = call_589253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589253.url(scheme.get, call_589253.host, call_589253.base,
                         call_589253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589253, url, valid)

proc call*(call_589254: Call_DlpProjectsDeidentifyTemplatesCreate_589235;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDeidentifyTemplatesCreate
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589255 = newJObject()
  var query_589256 = newJObject()
  var body_589257 = newJObject()
  add(query_589256, "upload_protocol", newJString(uploadProtocol))
  add(query_589256, "fields", newJString(fields))
  add(query_589256, "quotaUser", newJString(quotaUser))
  add(query_589256, "alt", newJString(alt))
  add(query_589256, "pp", newJBool(pp))
  add(query_589256, "oauth_token", newJString(oauthToken))
  add(query_589256, "callback", newJString(callback))
  add(query_589256, "access_token", newJString(accessToken))
  add(query_589256, "uploadType", newJString(uploadType))
  add(path_589255, "parent", newJString(parent))
  add(query_589256, "key", newJString(key))
  add(query_589256, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589257 = body
  add(query_589256, "prettyPrint", newJBool(prettyPrint))
  add(query_589256, "bearer_token", newJString(bearerToken))
  result = call_589254.call(path_589255, query_589256, nil, nil, body_589257)

var dlpProjectsDeidentifyTemplatesCreate* = Call_DlpProjectsDeidentifyTemplatesCreate_589235(
    name: "dlpProjectsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/deidentifyTemplates",
    validator: validate_DlpProjectsDeidentifyTemplatesCreate_589236, base: "/",
    url: url_DlpProjectsDeidentifyTemplatesCreate_589237, schemes: {Scheme.Https})
type
  Call_DlpProjectsDeidentifyTemplatesList_589212 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDeidentifyTemplatesList_589214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDeidentifyTemplatesList_589213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists inspect templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589215 = path.getOrDefault("parent")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "parent", valid_589215
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589216 = query.getOrDefault("upload_protocol")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "upload_protocol", valid_589216
  var valid_589217 = query.getOrDefault("fields")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "fields", valid_589217
  var valid_589218 = query.getOrDefault("pageToken")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "pageToken", valid_589218
  var valid_589219 = query.getOrDefault("quotaUser")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "quotaUser", valid_589219
  var valid_589220 = query.getOrDefault("alt")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("json"))
  if valid_589220 != nil:
    section.add "alt", valid_589220
  var valid_589221 = query.getOrDefault("pp")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "pp", valid_589221
  var valid_589222 = query.getOrDefault("oauth_token")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "oauth_token", valid_589222
  var valid_589223 = query.getOrDefault("callback")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "callback", valid_589223
  var valid_589224 = query.getOrDefault("access_token")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "access_token", valid_589224
  var valid_589225 = query.getOrDefault("uploadType")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "uploadType", valid_589225
  var valid_589226 = query.getOrDefault("key")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "key", valid_589226
  var valid_589227 = query.getOrDefault("$.xgafv")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = newJString("1"))
  if valid_589227 != nil:
    section.add "$.xgafv", valid_589227
  var valid_589228 = query.getOrDefault("pageSize")
  valid_589228 = validateParameter(valid_589228, JInt, required = false, default = nil)
  if valid_589228 != nil:
    section.add "pageSize", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
  var valid_589230 = query.getOrDefault("bearer_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "bearer_token", valid_589230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589231: Call_DlpProjectsDeidentifyTemplatesList_589212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists inspect templates.
  ## 
  let valid = call_589231.validator(path, query, header, formData, body)
  let scheme = call_589231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589231.url(scheme.get, call_589231.host, call_589231.base,
                         call_589231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589231, url, valid)

proc call*(call_589232: Call_DlpProjectsDeidentifyTemplatesList_589212;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsDeidentifyTemplatesList
  ## Lists inspect templates.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589233 = newJObject()
  var query_589234 = newJObject()
  add(query_589234, "upload_protocol", newJString(uploadProtocol))
  add(query_589234, "fields", newJString(fields))
  add(query_589234, "pageToken", newJString(pageToken))
  add(query_589234, "quotaUser", newJString(quotaUser))
  add(query_589234, "alt", newJString(alt))
  add(query_589234, "pp", newJBool(pp))
  add(query_589234, "oauth_token", newJString(oauthToken))
  add(query_589234, "callback", newJString(callback))
  add(query_589234, "access_token", newJString(accessToken))
  add(query_589234, "uploadType", newJString(uploadType))
  add(path_589233, "parent", newJString(parent))
  add(query_589234, "key", newJString(key))
  add(query_589234, "$.xgafv", newJString(Xgafv))
  add(query_589234, "pageSize", newJInt(pageSize))
  add(query_589234, "prettyPrint", newJBool(prettyPrint))
  add(query_589234, "bearer_token", newJString(bearerToken))
  result = call_589232.call(path_589233, query_589234, nil, nil, nil)

var dlpProjectsDeidentifyTemplatesList* = Call_DlpProjectsDeidentifyTemplatesList_589212(
    name: "dlpProjectsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/deidentifyTemplates",
    validator: validate_DlpProjectsDeidentifyTemplatesList_589213, base: "/",
    url: url_DlpProjectsDeidentifyTemplatesList_589214, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_589258 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsDlpJobsList_589260(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsList_589259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DlpJobs that match the specified filter in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589261 = path.getOrDefault("parent")
  valid_589261 = validateParameter(valid_589261, JString, required = true,
                                 default = nil)
  if valid_589261 != nil:
    section.add "parent", valid_589261
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589262 = query.getOrDefault("upload_protocol")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "upload_protocol", valid_589262
  var valid_589263 = query.getOrDefault("fields")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "fields", valid_589263
  var valid_589264 = query.getOrDefault("pageToken")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "pageToken", valid_589264
  var valid_589265 = query.getOrDefault("quotaUser")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "quotaUser", valid_589265
  var valid_589266 = query.getOrDefault("alt")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("json"))
  if valid_589266 != nil:
    section.add "alt", valid_589266
  var valid_589267 = query.getOrDefault("pp")
  valid_589267 = validateParameter(valid_589267, JBool, required = false,
                                 default = newJBool(true))
  if valid_589267 != nil:
    section.add "pp", valid_589267
  var valid_589268 = query.getOrDefault("type")
  valid_589268 = validateParameter(valid_589268, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_589268 != nil:
    section.add "type", valid_589268
  var valid_589269 = query.getOrDefault("oauth_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "oauth_token", valid_589269
  var valid_589270 = query.getOrDefault("callback")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "callback", valid_589270
  var valid_589271 = query.getOrDefault("access_token")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "access_token", valid_589271
  var valid_589272 = query.getOrDefault("uploadType")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "uploadType", valid_589272
  var valid_589273 = query.getOrDefault("key")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "key", valid_589273
  var valid_589274 = query.getOrDefault("$.xgafv")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = newJString("1"))
  if valid_589274 != nil:
    section.add "$.xgafv", valid_589274
  var valid_589275 = query.getOrDefault("pageSize")
  valid_589275 = validateParameter(valid_589275, JInt, required = false, default = nil)
  if valid_589275 != nil:
    section.add "pageSize", valid_589275
  var valid_589276 = query.getOrDefault("prettyPrint")
  valid_589276 = validateParameter(valid_589276, JBool, required = false,
                                 default = newJBool(true))
  if valid_589276 != nil:
    section.add "prettyPrint", valid_589276
  var valid_589277 = query.getOrDefault("filter")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "filter", valid_589277
  var valid_589278 = query.getOrDefault("bearer_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "bearer_token", valid_589278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589279: Call_DlpProjectsDlpJobsList_589258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## 
  let valid = call_589279.validator(path, query, header, formData, body)
  let scheme = call_589279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589279.url(scheme.get, call_589279.host, call_589279.base,
                         call_589279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589279, url, valid)

proc call*(call_589280: Call_DlpProjectsDlpJobsList_589258; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          `type`: string = "DLP_JOB_TYPE_UNSPECIFIED"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
  ## dlpProjectsDlpJobsList
  ## Lists DlpJobs that match the specified filter in the request.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589281 = newJObject()
  var query_589282 = newJObject()
  add(query_589282, "upload_protocol", newJString(uploadProtocol))
  add(query_589282, "fields", newJString(fields))
  add(query_589282, "pageToken", newJString(pageToken))
  add(query_589282, "quotaUser", newJString(quotaUser))
  add(query_589282, "alt", newJString(alt))
  add(query_589282, "pp", newJBool(pp))
  add(query_589282, "type", newJString(`type`))
  add(query_589282, "oauth_token", newJString(oauthToken))
  add(query_589282, "callback", newJString(callback))
  add(query_589282, "access_token", newJString(accessToken))
  add(query_589282, "uploadType", newJString(uploadType))
  add(path_589281, "parent", newJString(parent))
  add(query_589282, "key", newJString(key))
  add(query_589282, "$.xgafv", newJString(Xgafv))
  add(query_589282, "pageSize", newJInt(pageSize))
  add(query_589282, "prettyPrint", newJBool(prettyPrint))
  add(query_589282, "filter", newJString(filter))
  add(query_589282, "bearer_token", newJString(bearerToken))
  result = call_589280.call(path_589281, query_589282, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_589258(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_589259, base: "/",
    url: url_DlpProjectsDlpJobsList_589260, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_589283 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsImageRedact_589285(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/image:redact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsImageRedact_589284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589286 = path.getOrDefault("parent")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "parent", valid_589286
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589287 = query.getOrDefault("upload_protocol")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "upload_protocol", valid_589287
  var valid_589288 = query.getOrDefault("fields")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "fields", valid_589288
  var valid_589289 = query.getOrDefault("quotaUser")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "quotaUser", valid_589289
  var valid_589290 = query.getOrDefault("alt")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("json"))
  if valid_589290 != nil:
    section.add "alt", valid_589290
  var valid_589291 = query.getOrDefault("pp")
  valid_589291 = validateParameter(valid_589291, JBool, required = false,
                                 default = newJBool(true))
  if valid_589291 != nil:
    section.add "pp", valid_589291
  var valid_589292 = query.getOrDefault("oauth_token")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "oauth_token", valid_589292
  var valid_589293 = query.getOrDefault("callback")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "callback", valid_589293
  var valid_589294 = query.getOrDefault("access_token")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "access_token", valid_589294
  var valid_589295 = query.getOrDefault("uploadType")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "uploadType", valid_589295
  var valid_589296 = query.getOrDefault("key")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "key", valid_589296
  var valid_589297 = query.getOrDefault("$.xgafv")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("1"))
  if valid_589297 != nil:
    section.add "$.xgafv", valid_589297
  var valid_589298 = query.getOrDefault("prettyPrint")
  valid_589298 = validateParameter(valid_589298, JBool, required = false,
                                 default = newJBool(true))
  if valid_589298 != nil:
    section.add "prettyPrint", valid_589298
  var valid_589299 = query.getOrDefault("bearer_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "bearer_token", valid_589299
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

proc call*(call_589301: Call_DlpProjectsImageRedact_589283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ## 
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_DlpProjectsImageRedact_589283; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  var body_589305 = newJObject()
  add(query_589304, "upload_protocol", newJString(uploadProtocol))
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "pp", newJBool(pp))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "callback", newJString(callback))
  add(query_589304, "access_token", newJString(accessToken))
  add(query_589304, "uploadType", newJString(uploadType))
  add(path_589303, "parent", newJString(parent))
  add(query_589304, "key", newJString(key))
  add(query_589304, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589305 = body
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  add(query_589304, "bearer_token", newJString(bearerToken))
  result = call_589302.call(path_589303, query_589304, nil, nil, body_589305)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_589283(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_589284, base: "/",
    url: url_DlpProjectsImageRedact_589285, schemes: {Scheme.Https})
type
  Call_DlpProjectsInspectTemplatesCreate_589329 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsInspectTemplatesCreate_589331(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsInspectTemplatesCreate_589330(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589332 = path.getOrDefault("parent")
  valid_589332 = validateParameter(valid_589332, JString, required = true,
                                 default = nil)
  if valid_589332 != nil:
    section.add "parent", valid_589332
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589333 = query.getOrDefault("upload_protocol")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "upload_protocol", valid_589333
  var valid_589334 = query.getOrDefault("fields")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "fields", valid_589334
  var valid_589335 = query.getOrDefault("quotaUser")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "quotaUser", valid_589335
  var valid_589336 = query.getOrDefault("alt")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = newJString("json"))
  if valid_589336 != nil:
    section.add "alt", valid_589336
  var valid_589337 = query.getOrDefault("pp")
  valid_589337 = validateParameter(valid_589337, JBool, required = false,
                                 default = newJBool(true))
  if valid_589337 != nil:
    section.add "pp", valid_589337
  var valid_589338 = query.getOrDefault("oauth_token")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "oauth_token", valid_589338
  var valid_589339 = query.getOrDefault("callback")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "callback", valid_589339
  var valid_589340 = query.getOrDefault("access_token")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "access_token", valid_589340
  var valid_589341 = query.getOrDefault("uploadType")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "uploadType", valid_589341
  var valid_589342 = query.getOrDefault("key")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "key", valid_589342
  var valid_589343 = query.getOrDefault("$.xgafv")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("1"))
  if valid_589343 != nil:
    section.add "$.xgafv", valid_589343
  var valid_589344 = query.getOrDefault("prettyPrint")
  valid_589344 = validateParameter(valid_589344, JBool, required = false,
                                 default = newJBool(true))
  if valid_589344 != nil:
    section.add "prettyPrint", valid_589344
  var valid_589345 = query.getOrDefault("bearer_token")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "bearer_token", valid_589345
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

proc call*(call_589347: Call_DlpProjectsInspectTemplatesCreate_589329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## 
  let valid = call_589347.validator(path, query, header, formData, body)
  let scheme = call_589347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589347.url(scheme.get, call_589347.host, call_589347.base,
                         call_589347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589347, url, valid)

proc call*(call_589348: Call_DlpProjectsInspectTemplatesCreate_589329;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsInspectTemplatesCreate
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589349 = newJObject()
  var query_589350 = newJObject()
  var body_589351 = newJObject()
  add(query_589350, "upload_protocol", newJString(uploadProtocol))
  add(query_589350, "fields", newJString(fields))
  add(query_589350, "quotaUser", newJString(quotaUser))
  add(query_589350, "alt", newJString(alt))
  add(query_589350, "pp", newJBool(pp))
  add(query_589350, "oauth_token", newJString(oauthToken))
  add(query_589350, "callback", newJString(callback))
  add(query_589350, "access_token", newJString(accessToken))
  add(query_589350, "uploadType", newJString(uploadType))
  add(path_589349, "parent", newJString(parent))
  add(query_589350, "key", newJString(key))
  add(query_589350, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589351 = body
  add(query_589350, "prettyPrint", newJBool(prettyPrint))
  add(query_589350, "bearer_token", newJString(bearerToken))
  result = call_589348.call(path_589349, query_589350, nil, nil, body_589351)

var dlpProjectsInspectTemplatesCreate* = Call_DlpProjectsInspectTemplatesCreate_589329(
    name: "dlpProjectsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/inspectTemplates",
    validator: validate_DlpProjectsInspectTemplatesCreate_589330, base: "/",
    url: url_DlpProjectsInspectTemplatesCreate_589331, schemes: {Scheme.Https})
type
  Call_DlpProjectsInspectTemplatesList_589306 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsInspectTemplatesList_589308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsInspectTemplatesList_589307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists inspect templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589309 = path.getOrDefault("parent")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "parent", valid_589309
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589310 = query.getOrDefault("upload_protocol")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "upload_protocol", valid_589310
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("pageToken")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "pageToken", valid_589312
  var valid_589313 = query.getOrDefault("quotaUser")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "quotaUser", valid_589313
  var valid_589314 = query.getOrDefault("alt")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = newJString("json"))
  if valid_589314 != nil:
    section.add "alt", valid_589314
  var valid_589315 = query.getOrDefault("pp")
  valid_589315 = validateParameter(valid_589315, JBool, required = false,
                                 default = newJBool(true))
  if valid_589315 != nil:
    section.add "pp", valid_589315
  var valid_589316 = query.getOrDefault("oauth_token")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "oauth_token", valid_589316
  var valid_589317 = query.getOrDefault("callback")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "callback", valid_589317
  var valid_589318 = query.getOrDefault("access_token")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "access_token", valid_589318
  var valid_589319 = query.getOrDefault("uploadType")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "uploadType", valid_589319
  var valid_589320 = query.getOrDefault("key")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "key", valid_589320
  var valid_589321 = query.getOrDefault("$.xgafv")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("1"))
  if valid_589321 != nil:
    section.add "$.xgafv", valid_589321
  var valid_589322 = query.getOrDefault("pageSize")
  valid_589322 = validateParameter(valid_589322, JInt, required = false, default = nil)
  if valid_589322 != nil:
    section.add "pageSize", valid_589322
  var valid_589323 = query.getOrDefault("prettyPrint")
  valid_589323 = validateParameter(valid_589323, JBool, required = false,
                                 default = newJBool(true))
  if valid_589323 != nil:
    section.add "prettyPrint", valid_589323
  var valid_589324 = query.getOrDefault("bearer_token")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "bearer_token", valid_589324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589325: Call_DlpProjectsInspectTemplatesList_589306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists inspect templates.
  ## 
  let valid = call_589325.validator(path, query, header, formData, body)
  let scheme = call_589325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589325.url(scheme.get, call_589325.host, call_589325.base,
                         call_589325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589325, url, valid)

proc call*(call_589326: Call_DlpProjectsInspectTemplatesList_589306;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsInspectTemplatesList
  ## Lists inspect templates.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589327 = newJObject()
  var query_589328 = newJObject()
  add(query_589328, "upload_protocol", newJString(uploadProtocol))
  add(query_589328, "fields", newJString(fields))
  add(query_589328, "pageToken", newJString(pageToken))
  add(query_589328, "quotaUser", newJString(quotaUser))
  add(query_589328, "alt", newJString(alt))
  add(query_589328, "pp", newJBool(pp))
  add(query_589328, "oauth_token", newJString(oauthToken))
  add(query_589328, "callback", newJString(callback))
  add(query_589328, "access_token", newJString(accessToken))
  add(query_589328, "uploadType", newJString(uploadType))
  add(path_589327, "parent", newJString(parent))
  add(query_589328, "key", newJString(key))
  add(query_589328, "$.xgafv", newJString(Xgafv))
  add(query_589328, "pageSize", newJInt(pageSize))
  add(query_589328, "prettyPrint", newJBool(prettyPrint))
  add(query_589328, "bearer_token", newJString(bearerToken))
  result = call_589326.call(path_589327, query_589328, nil, nil, nil)

var dlpProjectsInspectTemplatesList* = Call_DlpProjectsInspectTemplatesList_589306(
    name: "dlpProjectsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/inspectTemplates",
    validator: validate_DlpProjectsInspectTemplatesList_589307, base: "/",
    url: url_DlpProjectsInspectTemplatesList_589308, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_589376 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersCreate_589378(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersCreate_589377(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589379 = path.getOrDefault("parent")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "parent", valid_589379
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589380 = query.getOrDefault("upload_protocol")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "upload_protocol", valid_589380
  var valid_589381 = query.getOrDefault("fields")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "fields", valid_589381
  var valid_589382 = query.getOrDefault("quotaUser")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "quotaUser", valid_589382
  var valid_589383 = query.getOrDefault("alt")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = newJString("json"))
  if valid_589383 != nil:
    section.add "alt", valid_589383
  var valid_589384 = query.getOrDefault("pp")
  valid_589384 = validateParameter(valid_589384, JBool, required = false,
                                 default = newJBool(true))
  if valid_589384 != nil:
    section.add "pp", valid_589384
  var valid_589385 = query.getOrDefault("oauth_token")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "oauth_token", valid_589385
  var valid_589386 = query.getOrDefault("callback")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "callback", valid_589386
  var valid_589387 = query.getOrDefault("access_token")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "access_token", valid_589387
  var valid_589388 = query.getOrDefault("uploadType")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "uploadType", valid_589388
  var valid_589389 = query.getOrDefault("key")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "key", valid_589389
  var valid_589390 = query.getOrDefault("$.xgafv")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = newJString("1"))
  if valid_589390 != nil:
    section.add "$.xgafv", valid_589390
  var valid_589391 = query.getOrDefault("prettyPrint")
  valid_589391 = validateParameter(valid_589391, JBool, required = false,
                                 default = newJBool(true))
  if valid_589391 != nil:
    section.add "prettyPrint", valid_589391
  var valid_589392 = query.getOrDefault("bearer_token")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "bearer_token", valid_589392
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

proc call*(call_589394: Call_DlpProjectsJobTriggersCreate_589376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ## 
  let valid = call_589394.validator(path, query, header, formData, body)
  let scheme = call_589394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589394.url(scheme.get, call_589394.host, call_589394.base,
                         call_589394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589394, url, valid)

proc call*(call_589395: Call_DlpProjectsJobTriggersCreate_589376; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersCreate
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589396 = newJObject()
  var query_589397 = newJObject()
  var body_589398 = newJObject()
  add(query_589397, "upload_protocol", newJString(uploadProtocol))
  add(query_589397, "fields", newJString(fields))
  add(query_589397, "quotaUser", newJString(quotaUser))
  add(query_589397, "alt", newJString(alt))
  add(query_589397, "pp", newJBool(pp))
  add(query_589397, "oauth_token", newJString(oauthToken))
  add(query_589397, "callback", newJString(callback))
  add(query_589397, "access_token", newJString(accessToken))
  add(query_589397, "uploadType", newJString(uploadType))
  add(path_589396, "parent", newJString(parent))
  add(query_589397, "key", newJString(key))
  add(query_589397, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589398 = body
  add(query_589397, "prettyPrint", newJBool(prettyPrint))
  add(query_589397, "bearer_token", newJString(bearerToken))
  result = call_589395.call(path_589396, query_589397, nil, nil, body_589398)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_589376(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_589377, base: "/",
    url: url_DlpProjectsJobTriggersCreate_589378, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_589352 = ref object of OpenApiRestCall_588450
proc url_DlpProjectsJobTriggersList_589354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersList_589353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists job triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589355 = path.getOrDefault("parent")
  valid_589355 = validateParameter(valid_589355, JString, required = true,
                                 default = nil)
  if valid_589355 != nil:
    section.add "parent", valid_589355
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` and `filter` should not change for
  ## subsequent calls, but can be omitted if token is specified.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ## followed by 'asc/desc' postfix, i.e.
  ## `"create_time asc,name desc,schedule_mode asc"`. This list is
  ## case-insensitive.
  ## 
  ## Example: `"name asc,schedule_mode desc, status desc"`
  ## 
  ## Supported filters keys and values are:
  ## 
  ## - `create_time`: corresponds to time the triggeredJob was created.
  ## - `update_time`: corresponds to time the triggeredJob was last updated.
  ## - `name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to the triggeredJob status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589356 = query.getOrDefault("upload_protocol")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "upload_protocol", valid_589356
  var valid_589357 = query.getOrDefault("fields")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "fields", valid_589357
  var valid_589358 = query.getOrDefault("pageToken")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "pageToken", valid_589358
  var valid_589359 = query.getOrDefault("quotaUser")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "quotaUser", valid_589359
  var valid_589360 = query.getOrDefault("alt")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = newJString("json"))
  if valid_589360 != nil:
    section.add "alt", valid_589360
  var valid_589361 = query.getOrDefault("pp")
  valid_589361 = validateParameter(valid_589361, JBool, required = false,
                                 default = newJBool(true))
  if valid_589361 != nil:
    section.add "pp", valid_589361
  var valid_589362 = query.getOrDefault("oauth_token")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "oauth_token", valid_589362
  var valid_589363 = query.getOrDefault("callback")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "callback", valid_589363
  var valid_589364 = query.getOrDefault("access_token")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "access_token", valid_589364
  var valid_589365 = query.getOrDefault("uploadType")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "uploadType", valid_589365
  var valid_589366 = query.getOrDefault("orderBy")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "orderBy", valid_589366
  var valid_589367 = query.getOrDefault("key")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "key", valid_589367
  var valid_589368 = query.getOrDefault("$.xgafv")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = newJString("1"))
  if valid_589368 != nil:
    section.add "$.xgafv", valid_589368
  var valid_589369 = query.getOrDefault("pageSize")
  valid_589369 = validateParameter(valid_589369, JInt, required = false, default = nil)
  if valid_589369 != nil:
    section.add "pageSize", valid_589369
  var valid_589370 = query.getOrDefault("prettyPrint")
  valid_589370 = validateParameter(valid_589370, JBool, required = false,
                                 default = newJBool(true))
  if valid_589370 != nil:
    section.add "prettyPrint", valid_589370
  var valid_589371 = query.getOrDefault("bearer_token")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "bearer_token", valid_589371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589372: Call_DlpProjectsJobTriggersList_589352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## 
  let valid = call_589372.validator(path, query, header, formData, body)
  let scheme = call_589372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589372.url(scheme.get, call_589372.host, call_589372.base,
                         call_589372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589372, url, valid)

proc call*(call_589373: Call_DlpProjectsJobTriggersList_589352; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersList
  ## Lists job triggers.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` and `filter` should not change for
  ## subsequent calls, but can be omitted if token is specified.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by 'asc/desc' postfix, i.e.
  ## `"create_time asc,name desc,schedule_mode asc"`. This list is
  ## case-insensitive.
  ## 
  ## Example: `"name asc,schedule_mode desc, status desc"`
  ## 
  ## Supported filters keys and values are:
  ## 
  ## - `create_time`: corresponds to time the triggeredJob was created.
  ## - `update_time`: corresponds to time the triggeredJob was last updated.
  ## - `name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to the triggeredJob status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589374 = newJObject()
  var query_589375 = newJObject()
  add(query_589375, "upload_protocol", newJString(uploadProtocol))
  add(query_589375, "fields", newJString(fields))
  add(query_589375, "pageToken", newJString(pageToken))
  add(query_589375, "quotaUser", newJString(quotaUser))
  add(query_589375, "alt", newJString(alt))
  add(query_589375, "pp", newJBool(pp))
  add(query_589375, "oauth_token", newJString(oauthToken))
  add(query_589375, "callback", newJString(callback))
  add(query_589375, "access_token", newJString(accessToken))
  add(query_589375, "uploadType", newJString(uploadType))
  add(path_589374, "parent", newJString(parent))
  add(query_589375, "orderBy", newJString(orderBy))
  add(query_589375, "key", newJString(key))
  add(query_589375, "$.xgafv", newJString(Xgafv))
  add(query_589375, "pageSize", newJInt(pageSize))
  add(query_589375, "prettyPrint", newJBool(prettyPrint))
  add(query_589375, "bearer_token", newJString(bearerToken))
  result = call_589373.call(path_589374, query_589375, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_589352(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_589353, base: "/",
    url: url_DlpProjectsJobTriggersList_589354, schemes: {Scheme.Https})
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
