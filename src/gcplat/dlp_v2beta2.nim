
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "dlp"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DlpInfoTypesList_578619 = ref object of OpenApiRestCall_578348
proc url_DlpInfoTypesList_578621(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpInfoTypesList_578620(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns sensitive information types DLP supports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("pp")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "pp", valid_578747
  var valid_578748 = query.getOrDefault("prettyPrint")
  valid_578748 = validateParameter(valid_578748, JBool, required = false,
                                 default = newJBool(true))
  if valid_578748 != nil:
    section.add "prettyPrint", valid_578748
  var valid_578749 = query.getOrDefault("oauth_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "oauth_token", valid_578749
  var valid_578750 = query.getOrDefault("$.xgafv")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("1"))
  if valid_578750 != nil:
    section.add "$.xgafv", valid_578750
  var valid_578751 = query.getOrDefault("bearer_token")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "bearer_token", valid_578751
  var valid_578752 = query.getOrDefault("alt")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = newJString("json"))
  if valid_578752 != nil:
    section.add "alt", valid_578752
  var valid_578753 = query.getOrDefault("uploadType")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "uploadType", valid_578753
  var valid_578754 = query.getOrDefault("quotaUser")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "quotaUser", valid_578754
  var valid_578755 = query.getOrDefault("filter")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "filter", valid_578755
  var valid_578756 = query.getOrDefault("callback")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "callback", valid_578756
  var valid_578757 = query.getOrDefault("languageCode")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "languageCode", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  var valid_578759 = query.getOrDefault("access_token")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "access_token", valid_578759
  var valid_578760 = query.getOrDefault("upload_protocol")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "upload_protocol", valid_578760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578783: Call_DlpInfoTypesList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns sensitive information types DLP supports.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_DlpInfoTypesList_578619; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpInfoTypesList
  ## Returns sensitive information types DLP supports.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578855 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "pp", newJBool(pp))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "$.xgafv", newJString(Xgafv))
  add(query_578855, "bearer_token", newJString(bearerToken))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "uploadType", newJString(uploadType))
  add(query_578855, "quotaUser", newJString(quotaUser))
  add(query_578855, "filter", newJString(filter))
  add(query_578855, "callback", newJString(callback))
  add(query_578855, "languageCode", newJString(languageCode))
  add(query_578855, "fields", newJString(fields))
  add(query_578855, "access_token", newJString(accessToken))
  add(query_578855, "upload_protocol", newJString(uploadProtocol))
  result = call_578854.call(nil, query_578855, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_578619(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com",
    route: "/v2beta2/infoTypes", validator: validate_DlpInfoTypesList_578620,
    base: "/", url: url_DlpInfoTypesList_578621, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersGet_578895 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersGet_578897(protocol: Scheme; host: string;
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

proc validate_DlpProjectsJobTriggersGet_578896(path: JsonNode; query: JsonNode;
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
  var valid_578912 = path.getOrDefault("name")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "name", valid_578912
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("pp")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "pp", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("$.xgafv")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("1"))
  if valid_578917 != nil:
    section.add "$.xgafv", valid_578917
  var valid_578918 = query.getOrDefault("bearer_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "bearer_token", valid_578918
  var valid_578919 = query.getOrDefault("alt")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("json"))
  if valid_578919 != nil:
    section.add "alt", valid_578919
  var valid_578920 = query.getOrDefault("uploadType")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "uploadType", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("callback")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "callback", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  var valid_578924 = query.getOrDefault("access_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "access_token", valid_578924
  var valid_578925 = query.getOrDefault("upload_protocol")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "upload_protocol", valid_578925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578926: Call_DlpProjectsJobTriggersGet_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job trigger.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_DlpProjectsJobTriggersGet_578895; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersGet
  ## Gets a job trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "pp", newJBool(pp))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "bearer_token", newJString(bearerToken))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "name", newJString(name))
  add(query_578929, "callback", newJString(callback))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "access_token", newJString(accessToken))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  result = call_578927.call(path_578928, query_578929, nil, nil, nil)

var dlpProjectsJobTriggersGet* = Call_DlpProjectsJobTriggersGet_578895(
    name: "dlpProjectsJobTriggersGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersGet_578896, base: "/",
    url: url_DlpProjectsJobTriggersGet_578897, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersPatch_578951 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersPatch_578953(protocol: Scheme; host: string;
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

proc validate_DlpProjectsJobTriggersPatch_578952(path: JsonNode; query: JsonNode;
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
  var valid_578954 = path.getOrDefault("name")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "name", valid_578954
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("pp")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "pp", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("$.xgafv")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("1"))
  if valid_578959 != nil:
    section.add "$.xgafv", valid_578959
  var valid_578960 = query.getOrDefault("bearer_token")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "bearer_token", valid_578960
  var valid_578961 = query.getOrDefault("alt")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("json"))
  if valid_578961 != nil:
    section.add "alt", valid_578961
  var valid_578962 = query.getOrDefault("uploadType")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "uploadType", valid_578962
  var valid_578963 = query.getOrDefault("quotaUser")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "quotaUser", valid_578963
  var valid_578964 = query.getOrDefault("callback")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "callback", valid_578964
  var valid_578965 = query.getOrDefault("fields")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "fields", valid_578965
  var valid_578966 = query.getOrDefault("access_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "access_token", valid_578966
  var valid_578967 = query.getOrDefault("upload_protocol")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "upload_protocol", valid_578967
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

proc call*(call_578969: Call_DlpProjectsJobTriggersPatch_578951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job trigger.
  ## 
  let valid = call_578969.validator(path, query, header, formData, body)
  let scheme = call_578969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578969.url(scheme.get, call_578969.host, call_578969.base,
                         call_578969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578969, url, valid)

proc call*(call_578970: Call_DlpProjectsJobTriggersPatch_578951; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersPatch
  ## Updates a job trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578971 = newJObject()
  var query_578972 = newJObject()
  var body_578973 = newJObject()
  add(query_578972, "key", newJString(key))
  add(query_578972, "pp", newJBool(pp))
  add(query_578972, "prettyPrint", newJBool(prettyPrint))
  add(query_578972, "oauth_token", newJString(oauthToken))
  add(query_578972, "$.xgafv", newJString(Xgafv))
  add(query_578972, "bearer_token", newJString(bearerToken))
  add(query_578972, "alt", newJString(alt))
  add(query_578972, "uploadType", newJString(uploadType))
  add(query_578972, "quotaUser", newJString(quotaUser))
  add(path_578971, "name", newJString(name))
  if body != nil:
    body_578973 = body
  add(query_578972, "callback", newJString(callback))
  add(query_578972, "fields", newJString(fields))
  add(query_578972, "access_token", newJString(accessToken))
  add(query_578972, "upload_protocol", newJString(uploadProtocol))
  result = call_578970.call(path_578971, query_578972, nil, nil, body_578973)

var dlpProjectsJobTriggersPatch* = Call_DlpProjectsJobTriggersPatch_578951(
    name: "dlpProjectsJobTriggersPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersPatch_578952, base: "/",
    url: url_DlpProjectsJobTriggersPatch_578953, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersDelete_578930 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersDelete_578932(protocol: Scheme; host: string;
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

proc validate_DlpProjectsJobTriggersDelete_578931(path: JsonNode; query: JsonNode;
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
  var valid_578933 = path.getOrDefault("name")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "name", valid_578933
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("pp")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "pp", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("$.xgafv")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("1"))
  if valid_578938 != nil:
    section.add "$.xgafv", valid_578938
  var valid_578939 = query.getOrDefault("bearer_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "bearer_token", valid_578939
  var valid_578940 = query.getOrDefault("alt")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("json"))
  if valid_578940 != nil:
    section.add "alt", valid_578940
  var valid_578941 = query.getOrDefault("uploadType")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "uploadType", valid_578941
  var valid_578942 = query.getOrDefault("quotaUser")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "quotaUser", valid_578942
  var valid_578943 = query.getOrDefault("callback")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "callback", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  var valid_578945 = query.getOrDefault("access_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "access_token", valid_578945
  var valid_578946 = query.getOrDefault("upload_protocol")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "upload_protocol", valid_578946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578947: Call_DlpProjectsJobTriggersDelete_578930; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job trigger.
  ## 
  let valid = call_578947.validator(path, query, header, formData, body)
  let scheme = call_578947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578947.url(scheme.get, call_578947.host, call_578947.base,
                         call_578947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578947, url, valid)

proc call*(call_578948: Call_DlpProjectsJobTriggersDelete_578930; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersDelete
  ## Deletes a job trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578949 = newJObject()
  var query_578950 = newJObject()
  add(query_578950, "key", newJString(key))
  add(query_578950, "pp", newJBool(pp))
  add(query_578950, "prettyPrint", newJBool(prettyPrint))
  add(query_578950, "oauth_token", newJString(oauthToken))
  add(query_578950, "$.xgafv", newJString(Xgafv))
  add(query_578950, "bearer_token", newJString(bearerToken))
  add(query_578950, "alt", newJString(alt))
  add(query_578950, "uploadType", newJString(uploadType))
  add(query_578950, "quotaUser", newJString(quotaUser))
  add(path_578949, "name", newJString(name))
  add(query_578950, "callback", newJString(callback))
  add(query_578950, "fields", newJString(fields))
  add(query_578950, "access_token", newJString(accessToken))
  add(query_578950, "upload_protocol", newJString(uploadProtocol))
  result = call_578948.call(path_578949, query_578950, nil, nil, nil)

var dlpProjectsJobTriggersDelete* = Call_DlpProjectsJobTriggersDelete_578930(
    name: "dlpProjectsJobTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersDelete_578931, base: "/",
    url: url_DlpProjectsJobTriggersDelete_578932, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_578974 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDlpJobsCancel_578976(protocol: Scheme; host: string;
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

proc validate_DlpProjectsDlpJobsCancel_578975(path: JsonNode; query: JsonNode;
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
  var valid_578977 = path.getOrDefault("name")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "name", valid_578977
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578978 = query.getOrDefault("key")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "key", valid_578978
  var valid_578979 = query.getOrDefault("pp")
  valid_578979 = validateParameter(valid_578979, JBool, required = false,
                                 default = newJBool(true))
  if valid_578979 != nil:
    section.add "pp", valid_578979
  var valid_578980 = query.getOrDefault("prettyPrint")
  valid_578980 = validateParameter(valid_578980, JBool, required = false,
                                 default = newJBool(true))
  if valid_578980 != nil:
    section.add "prettyPrint", valid_578980
  var valid_578981 = query.getOrDefault("oauth_token")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "oauth_token", valid_578981
  var valid_578982 = query.getOrDefault("$.xgafv")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("1"))
  if valid_578982 != nil:
    section.add "$.xgafv", valid_578982
  var valid_578983 = query.getOrDefault("bearer_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "bearer_token", valid_578983
  var valid_578984 = query.getOrDefault("alt")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("json"))
  if valid_578984 != nil:
    section.add "alt", valid_578984
  var valid_578985 = query.getOrDefault("uploadType")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "uploadType", valid_578985
  var valid_578986 = query.getOrDefault("quotaUser")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "quotaUser", valid_578986
  var valid_578987 = query.getOrDefault("callback")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "callback", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
  var valid_578989 = query.getOrDefault("access_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "access_token", valid_578989
  var valid_578990 = query.getOrDefault("upload_protocol")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "upload_protocol", valid_578990
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

proc call*(call_578992: Call_DlpProjectsDlpJobsCancel_578974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_DlpProjectsDlpJobsCancel_578974; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsCancel
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the DlpJob resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578994 = newJObject()
  var query_578995 = newJObject()
  var body_578996 = newJObject()
  add(query_578995, "key", newJString(key))
  add(query_578995, "pp", newJBool(pp))
  add(query_578995, "prettyPrint", newJBool(prettyPrint))
  add(query_578995, "oauth_token", newJString(oauthToken))
  add(query_578995, "$.xgafv", newJString(Xgafv))
  add(query_578995, "bearer_token", newJString(bearerToken))
  add(query_578995, "alt", newJString(alt))
  add(query_578995, "uploadType", newJString(uploadType))
  add(query_578995, "quotaUser", newJString(quotaUser))
  add(path_578994, "name", newJString(name))
  if body != nil:
    body_578996 = body
  add(query_578995, "callback", newJString(callback))
  add(query_578995, "fields", newJString(fields))
  add(query_578995, "access_token", newJString(accessToken))
  add(query_578995, "upload_protocol", newJString(uploadProtocol))
  result = call_578993.call(path_578994, query_578995, nil, nil, body_578996)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_578974(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_578975, base: "/",
    url: url_DlpProjectsDlpJobsCancel_578976, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_578997 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsContentDeidentify_578999(protocol: Scheme; host: string;
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

proc validate_DlpProjectsContentDeidentify_578998(path: JsonNode; query: JsonNode;
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
  var valid_579000 = path.getOrDefault("parent")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "parent", valid_579000
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("pp")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "pp", valid_579002
  var valid_579003 = query.getOrDefault("prettyPrint")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "prettyPrint", valid_579003
  var valid_579004 = query.getOrDefault("oauth_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "oauth_token", valid_579004
  var valid_579005 = query.getOrDefault("$.xgafv")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("1"))
  if valid_579005 != nil:
    section.add "$.xgafv", valid_579005
  var valid_579006 = query.getOrDefault("bearer_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "bearer_token", valid_579006
  var valid_579007 = query.getOrDefault("alt")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("json"))
  if valid_579007 != nil:
    section.add "alt", valid_579007
  var valid_579008 = query.getOrDefault("uploadType")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "uploadType", valid_579008
  var valid_579009 = query.getOrDefault("quotaUser")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "quotaUser", valid_579009
  var valid_579010 = query.getOrDefault("callback")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "callback", valid_579010
  var valid_579011 = query.getOrDefault("fields")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "fields", valid_579011
  var valid_579012 = query.getOrDefault("access_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "access_token", valid_579012
  var valid_579013 = query.getOrDefault("upload_protocol")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "upload_protocol", valid_579013
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

proc call*(call_579015: Call_DlpProjectsContentDeidentify_578997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ## 
  let valid = call_579015.validator(path, query, header, formData, body)
  let scheme = call_579015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579015.url(scheme.get, call_579015.host, call_579015.base,
                         call_579015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579015, url, valid)

proc call*(call_579016: Call_DlpProjectsContentDeidentify_578997; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579017 = newJObject()
  var query_579018 = newJObject()
  var body_579019 = newJObject()
  add(query_579018, "key", newJString(key))
  add(query_579018, "pp", newJBool(pp))
  add(query_579018, "prettyPrint", newJBool(prettyPrint))
  add(query_579018, "oauth_token", newJString(oauthToken))
  add(query_579018, "$.xgafv", newJString(Xgafv))
  add(query_579018, "bearer_token", newJString(bearerToken))
  add(query_579018, "alt", newJString(alt))
  add(query_579018, "uploadType", newJString(uploadType))
  add(query_579018, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579019 = body
  add(query_579018, "callback", newJString(callback))
  add(path_579017, "parent", newJString(parent))
  add(query_579018, "fields", newJString(fields))
  add(query_579018, "access_token", newJString(accessToken))
  add(query_579018, "upload_protocol", newJString(uploadProtocol))
  result = call_579016.call(path_579017, query_579018, nil, nil, body_579019)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_578997(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_578998, base: "/",
    url: url_DlpProjectsContentDeidentify_578999, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_579020 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsContentInspect_579022(protocol: Scheme; host: string;
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

proc validate_DlpProjectsContentInspect_579021(path: JsonNode; query: JsonNode;
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
  var valid_579023 = path.getOrDefault("parent")
  valid_579023 = validateParameter(valid_579023, JString, required = true,
                                 default = nil)
  if valid_579023 != nil:
    section.add "parent", valid_579023
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579024 = query.getOrDefault("key")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "key", valid_579024
  var valid_579025 = query.getOrDefault("pp")
  valid_579025 = validateParameter(valid_579025, JBool, required = false,
                                 default = newJBool(true))
  if valid_579025 != nil:
    section.add "pp", valid_579025
  var valid_579026 = query.getOrDefault("prettyPrint")
  valid_579026 = validateParameter(valid_579026, JBool, required = false,
                                 default = newJBool(true))
  if valid_579026 != nil:
    section.add "prettyPrint", valid_579026
  var valid_579027 = query.getOrDefault("oauth_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "oauth_token", valid_579027
  var valid_579028 = query.getOrDefault("$.xgafv")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("1"))
  if valid_579028 != nil:
    section.add "$.xgafv", valid_579028
  var valid_579029 = query.getOrDefault("bearer_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "bearer_token", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("uploadType")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "uploadType", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("callback")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "callback", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  var valid_579035 = query.getOrDefault("access_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "access_token", valid_579035
  var valid_579036 = query.getOrDefault("upload_protocol")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "upload_protocol", valid_579036
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

proc call*(call_579038: Call_DlpProjectsContentInspect_579020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ## 
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_DlpProjectsContentInspect_579020; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  var body_579042 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "pp", newJBool(pp))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "$.xgafv", newJString(Xgafv))
  add(query_579041, "bearer_token", newJString(bearerToken))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "uploadType", newJString(uploadType))
  add(query_579041, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579042 = body
  add(query_579041, "callback", newJString(callback))
  add(path_579040, "parent", newJString(parent))
  add(query_579041, "fields", newJString(fields))
  add(query_579041, "access_token", newJString(accessToken))
  add(query_579041, "upload_protocol", newJString(uploadProtocol))
  result = call_579039.call(path_579040, query_579041, nil, nil, body_579042)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_579020(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_579021, base: "/",
    url: url_DlpProjectsContentInspect_579022, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_579043 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsContentReidentify_579045(protocol: Scheme; host: string;
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

proc validate_DlpProjectsContentReidentify_579044(path: JsonNode; query: JsonNode;
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
  var valid_579046 = path.getOrDefault("parent")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "parent", valid_579046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("pp")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "pp", valid_579048
  var valid_579049 = query.getOrDefault("prettyPrint")
  valid_579049 = validateParameter(valid_579049, JBool, required = false,
                                 default = newJBool(true))
  if valid_579049 != nil:
    section.add "prettyPrint", valid_579049
  var valid_579050 = query.getOrDefault("oauth_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "oauth_token", valid_579050
  var valid_579051 = query.getOrDefault("$.xgafv")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("1"))
  if valid_579051 != nil:
    section.add "$.xgafv", valid_579051
  var valid_579052 = query.getOrDefault("bearer_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "bearer_token", valid_579052
  var valid_579053 = query.getOrDefault("alt")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("json"))
  if valid_579053 != nil:
    section.add "alt", valid_579053
  var valid_579054 = query.getOrDefault("uploadType")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "uploadType", valid_579054
  var valid_579055 = query.getOrDefault("quotaUser")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "quotaUser", valid_579055
  var valid_579056 = query.getOrDefault("callback")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "callback", valid_579056
  var valid_579057 = query.getOrDefault("fields")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "fields", valid_579057
  var valid_579058 = query.getOrDefault("access_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "access_token", valid_579058
  var valid_579059 = query.getOrDefault("upload_protocol")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "upload_protocol", valid_579059
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

proc call*(call_579061: Call_DlpProjectsContentReidentify_579043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identify content that has been de-identified.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_DlpProjectsContentReidentify_579043; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentReidentify
  ## Re-identify content that has been de-identified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  var body_579065 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "pp", newJBool(pp))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "$.xgafv", newJString(Xgafv))
  add(query_579064, "bearer_token", newJString(bearerToken))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "uploadType", newJString(uploadType))
  add(query_579064, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579065 = body
  add(query_579064, "callback", newJString(callback))
  add(path_579063, "parent", newJString(parent))
  add(query_579064, "fields", newJString(fields))
  add(query_579064, "access_token", newJString(accessToken))
  add(query_579064, "upload_protocol", newJString(uploadProtocol))
  result = call_579062.call(path_579063, query_579064, nil, nil, body_579065)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_579043(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_579044, base: "/",
    url: url_DlpProjectsContentReidentify_579045, schemes: {Scheme.Https})
type
  Call_DlpProjectsDataSourceAnalyze_579066 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDataSourceAnalyze_579068(protocol: Scheme; host: string;
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

proc validate_DlpProjectsDataSourceAnalyze_579067(path: JsonNode; query: JsonNode;
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
  var valid_579069 = path.getOrDefault("parent")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "parent", valid_579069
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579070 = query.getOrDefault("key")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "key", valid_579070
  var valid_579071 = query.getOrDefault("pp")
  valid_579071 = validateParameter(valid_579071, JBool, required = false,
                                 default = newJBool(true))
  if valid_579071 != nil:
    section.add "pp", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("$.xgafv")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("1"))
  if valid_579074 != nil:
    section.add "$.xgafv", valid_579074
  var valid_579075 = query.getOrDefault("bearer_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "bearer_token", valid_579075
  var valid_579076 = query.getOrDefault("alt")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("json"))
  if valid_579076 != nil:
    section.add "alt", valid_579076
  var valid_579077 = query.getOrDefault("uploadType")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "uploadType", valid_579077
  var valid_579078 = query.getOrDefault("quotaUser")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "quotaUser", valid_579078
  var valid_579079 = query.getOrDefault("callback")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "callback", valid_579079
  var valid_579080 = query.getOrDefault("fields")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "fields", valid_579080
  var valid_579081 = query.getOrDefault("access_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "access_token", valid_579081
  var valid_579082 = query.getOrDefault("upload_protocol")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "upload_protocol", valid_579082
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

proc call*(call_579084: Call_DlpProjectsDataSourceAnalyze_579066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ## 
  let valid = call_579084.validator(path, query, header, formData, body)
  let scheme = call_579084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579084.url(scheme.get, call_579084.host, call_579084.base,
                         call_579084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579084, url, valid)

proc call*(call_579085: Call_DlpProjectsDataSourceAnalyze_579066; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDataSourceAnalyze
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579086 = newJObject()
  var query_579087 = newJObject()
  var body_579088 = newJObject()
  add(query_579087, "key", newJString(key))
  add(query_579087, "pp", newJBool(pp))
  add(query_579087, "prettyPrint", newJBool(prettyPrint))
  add(query_579087, "oauth_token", newJString(oauthToken))
  add(query_579087, "$.xgafv", newJString(Xgafv))
  add(query_579087, "bearer_token", newJString(bearerToken))
  add(query_579087, "alt", newJString(alt))
  add(query_579087, "uploadType", newJString(uploadType))
  add(query_579087, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579088 = body
  add(query_579087, "callback", newJString(callback))
  add(path_579086, "parent", newJString(parent))
  add(query_579087, "fields", newJString(fields))
  add(query_579087, "access_token", newJString(accessToken))
  add(query_579087, "upload_protocol", newJString(uploadProtocol))
  result = call_579085.call(path_579086, query_579087, nil, nil, body_579088)

var dlpProjectsDataSourceAnalyze* = Call_DlpProjectsDataSourceAnalyze_579066(
    name: "dlpProjectsDataSourceAnalyze", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dataSource:analyze",
    validator: validate_DlpProjectsDataSourceAnalyze_579067, base: "/",
    url: url_DlpProjectsDataSourceAnalyze_579068, schemes: {Scheme.Https})
type
  Call_DlpProjectsDataSourceInspect_579089 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDataSourceInspect_579091(protocol: Scheme; host: string;
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

proc validate_DlpProjectsDataSourceInspect_579090(path: JsonNode; query: JsonNode;
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
  var valid_579092 = path.getOrDefault("parent")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "parent", valid_579092
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("pp")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "pp", valid_579094
  var valid_579095 = query.getOrDefault("prettyPrint")
  valid_579095 = validateParameter(valid_579095, JBool, required = false,
                                 default = newJBool(true))
  if valid_579095 != nil:
    section.add "prettyPrint", valid_579095
  var valid_579096 = query.getOrDefault("oauth_token")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "oauth_token", valid_579096
  var valid_579097 = query.getOrDefault("$.xgafv")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = newJString("1"))
  if valid_579097 != nil:
    section.add "$.xgafv", valid_579097
  var valid_579098 = query.getOrDefault("bearer_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "bearer_token", valid_579098
  var valid_579099 = query.getOrDefault("alt")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("json"))
  if valid_579099 != nil:
    section.add "alt", valid_579099
  var valid_579100 = query.getOrDefault("uploadType")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "uploadType", valid_579100
  var valid_579101 = query.getOrDefault("quotaUser")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "quotaUser", valid_579101
  var valid_579102 = query.getOrDefault("callback")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "callback", valid_579102
  var valid_579103 = query.getOrDefault("fields")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "fields", valid_579103
  var valid_579104 = query.getOrDefault("access_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "access_token", valid_579104
  var valid_579105 = query.getOrDefault("upload_protocol")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "upload_protocol", valid_579105
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

proc call*(call_579107: Call_DlpProjectsDataSourceInspect_579089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ## 
  let valid = call_579107.validator(path, query, header, formData, body)
  let scheme = call_579107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579107.url(scheme.get, call_579107.host, call_579107.base,
                         call_579107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579107, url, valid)

proc call*(call_579108: Call_DlpProjectsDataSourceInspect_579089; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDataSourceInspect
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579109 = newJObject()
  var query_579110 = newJObject()
  var body_579111 = newJObject()
  add(query_579110, "key", newJString(key))
  add(query_579110, "pp", newJBool(pp))
  add(query_579110, "prettyPrint", newJBool(prettyPrint))
  add(query_579110, "oauth_token", newJString(oauthToken))
  add(query_579110, "$.xgafv", newJString(Xgafv))
  add(query_579110, "bearer_token", newJString(bearerToken))
  add(query_579110, "alt", newJString(alt))
  add(query_579110, "uploadType", newJString(uploadType))
  add(query_579110, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579111 = body
  add(query_579110, "callback", newJString(callback))
  add(path_579109, "parent", newJString(parent))
  add(query_579110, "fields", newJString(fields))
  add(query_579110, "access_token", newJString(accessToken))
  add(query_579110, "upload_protocol", newJString(uploadProtocol))
  result = call_579108.call(path_579109, query_579110, nil, nil, body_579111)

var dlpProjectsDataSourceInspect* = Call_DlpProjectsDataSourceInspect_579089(
    name: "dlpProjectsDataSourceInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dataSource:inspect",
    validator: validate_DlpProjectsDataSourceInspect_579090, base: "/",
    url: url_DlpProjectsDataSourceInspect_579091, schemes: {Scheme.Https})
type
  Call_DlpProjectsDeidentifyTemplatesCreate_579135 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDeidentifyTemplatesCreate_579137(protocol: Scheme;
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

proc validate_DlpProjectsDeidentifyTemplatesCreate_579136(path: JsonNode;
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
  var valid_579138 = path.getOrDefault("parent")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "parent", valid_579138
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("pp")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "pp", valid_579140
  var valid_579141 = query.getOrDefault("prettyPrint")
  valid_579141 = validateParameter(valid_579141, JBool, required = false,
                                 default = newJBool(true))
  if valid_579141 != nil:
    section.add "prettyPrint", valid_579141
  var valid_579142 = query.getOrDefault("oauth_token")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "oauth_token", valid_579142
  var valid_579143 = query.getOrDefault("$.xgafv")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("1"))
  if valid_579143 != nil:
    section.add "$.xgafv", valid_579143
  var valid_579144 = query.getOrDefault("bearer_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "bearer_token", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("uploadType")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "uploadType", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("callback")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "callback", valid_579148
  var valid_579149 = query.getOrDefault("fields")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "fields", valid_579149
  var valid_579150 = query.getOrDefault("access_token")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "access_token", valid_579150
  var valid_579151 = query.getOrDefault("upload_protocol")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "upload_protocol", valid_579151
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

proc call*(call_579153: Call_DlpProjectsDeidentifyTemplatesCreate_579135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ## 
  let valid = call_579153.validator(path, query, header, formData, body)
  let scheme = call_579153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579153.url(scheme.get, call_579153.host, call_579153.base,
                         call_579153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579153, url, valid)

proc call*(call_579154: Call_DlpProjectsDeidentifyTemplatesCreate_579135;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDeidentifyTemplatesCreate
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579155 = newJObject()
  var query_579156 = newJObject()
  var body_579157 = newJObject()
  add(query_579156, "key", newJString(key))
  add(query_579156, "pp", newJBool(pp))
  add(query_579156, "prettyPrint", newJBool(prettyPrint))
  add(query_579156, "oauth_token", newJString(oauthToken))
  add(query_579156, "$.xgafv", newJString(Xgafv))
  add(query_579156, "bearer_token", newJString(bearerToken))
  add(query_579156, "alt", newJString(alt))
  add(query_579156, "uploadType", newJString(uploadType))
  add(query_579156, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579157 = body
  add(query_579156, "callback", newJString(callback))
  add(path_579155, "parent", newJString(parent))
  add(query_579156, "fields", newJString(fields))
  add(query_579156, "access_token", newJString(accessToken))
  add(query_579156, "upload_protocol", newJString(uploadProtocol))
  result = call_579154.call(path_579155, query_579156, nil, nil, body_579157)

var dlpProjectsDeidentifyTemplatesCreate* = Call_DlpProjectsDeidentifyTemplatesCreate_579135(
    name: "dlpProjectsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/deidentifyTemplates",
    validator: validate_DlpProjectsDeidentifyTemplatesCreate_579136, base: "/",
    url: url_DlpProjectsDeidentifyTemplatesCreate_579137, schemes: {Scheme.Https})
type
  Call_DlpProjectsDeidentifyTemplatesList_579112 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDeidentifyTemplatesList_579114(protocol: Scheme; host: string;
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

proc validate_DlpProjectsDeidentifyTemplatesList_579113(path: JsonNode;
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
  var valid_579115 = path.getOrDefault("parent")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "parent", valid_579115
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579116 = query.getOrDefault("key")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "key", valid_579116
  var valid_579117 = query.getOrDefault("pp")
  valid_579117 = validateParameter(valid_579117, JBool, required = false,
                                 default = newJBool(true))
  if valid_579117 != nil:
    section.add "pp", valid_579117
  var valid_579118 = query.getOrDefault("prettyPrint")
  valid_579118 = validateParameter(valid_579118, JBool, required = false,
                                 default = newJBool(true))
  if valid_579118 != nil:
    section.add "prettyPrint", valid_579118
  var valid_579119 = query.getOrDefault("oauth_token")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "oauth_token", valid_579119
  var valid_579120 = query.getOrDefault("$.xgafv")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("1"))
  if valid_579120 != nil:
    section.add "$.xgafv", valid_579120
  var valid_579121 = query.getOrDefault("bearer_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "bearer_token", valid_579121
  var valid_579122 = query.getOrDefault("pageSize")
  valid_579122 = validateParameter(valid_579122, JInt, required = false, default = nil)
  if valid_579122 != nil:
    section.add "pageSize", valid_579122
  var valid_579123 = query.getOrDefault("alt")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("json"))
  if valid_579123 != nil:
    section.add "alt", valid_579123
  var valid_579124 = query.getOrDefault("uploadType")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "uploadType", valid_579124
  var valid_579125 = query.getOrDefault("quotaUser")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "quotaUser", valid_579125
  var valid_579126 = query.getOrDefault("pageToken")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "pageToken", valid_579126
  var valid_579127 = query.getOrDefault("callback")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "callback", valid_579127
  var valid_579128 = query.getOrDefault("fields")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "fields", valid_579128
  var valid_579129 = query.getOrDefault("access_token")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "access_token", valid_579129
  var valid_579130 = query.getOrDefault("upload_protocol")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "upload_protocol", valid_579130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579131: Call_DlpProjectsDeidentifyTemplatesList_579112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists inspect templates.
  ## 
  let valid = call_579131.validator(path, query, header, formData, body)
  let scheme = call_579131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579131.url(scheme.get, call_579131.host, call_579131.base,
                         call_579131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579131, url, valid)

proc call*(call_579132: Call_DlpProjectsDeidentifyTemplatesList_579112;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDeidentifyTemplatesList
  ## Lists inspect templates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579133 = newJObject()
  var query_579134 = newJObject()
  add(query_579134, "key", newJString(key))
  add(query_579134, "pp", newJBool(pp))
  add(query_579134, "prettyPrint", newJBool(prettyPrint))
  add(query_579134, "oauth_token", newJString(oauthToken))
  add(query_579134, "$.xgafv", newJString(Xgafv))
  add(query_579134, "bearer_token", newJString(bearerToken))
  add(query_579134, "pageSize", newJInt(pageSize))
  add(query_579134, "alt", newJString(alt))
  add(query_579134, "uploadType", newJString(uploadType))
  add(query_579134, "quotaUser", newJString(quotaUser))
  add(query_579134, "pageToken", newJString(pageToken))
  add(query_579134, "callback", newJString(callback))
  add(path_579133, "parent", newJString(parent))
  add(query_579134, "fields", newJString(fields))
  add(query_579134, "access_token", newJString(accessToken))
  add(query_579134, "upload_protocol", newJString(uploadProtocol))
  result = call_579132.call(path_579133, query_579134, nil, nil, nil)

var dlpProjectsDeidentifyTemplatesList* = Call_DlpProjectsDeidentifyTemplatesList_579112(
    name: "dlpProjectsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/deidentifyTemplates",
    validator: validate_DlpProjectsDeidentifyTemplatesList_579113, base: "/",
    url: url_DlpProjectsDeidentifyTemplatesList_579114, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_579158 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsDlpJobsList_579160(protocol: Scheme; host: string; base: string;
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

proc validate_DlpProjectsDlpJobsList_579159(path: JsonNode; query: JsonNode;
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
  var valid_579161 = path.getOrDefault("parent")
  valid_579161 = validateParameter(valid_579161, JString, required = true,
                                 default = nil)
  if valid_579161 != nil:
    section.add "parent", valid_579161
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   type: JString
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
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
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579162 = query.getOrDefault("key")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "key", valid_579162
  var valid_579163 = query.getOrDefault("pp")
  valid_579163 = validateParameter(valid_579163, JBool, required = false,
                                 default = newJBool(true))
  if valid_579163 != nil:
    section.add "pp", valid_579163
  var valid_579164 = query.getOrDefault("prettyPrint")
  valid_579164 = validateParameter(valid_579164, JBool, required = false,
                                 default = newJBool(true))
  if valid_579164 != nil:
    section.add "prettyPrint", valid_579164
  var valid_579165 = query.getOrDefault("oauth_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "oauth_token", valid_579165
  var valid_579166 = query.getOrDefault("$.xgafv")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("1"))
  if valid_579166 != nil:
    section.add "$.xgafv", valid_579166
  var valid_579167 = query.getOrDefault("bearer_token")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "bearer_token", valid_579167
  var valid_579168 = query.getOrDefault("pageSize")
  valid_579168 = validateParameter(valid_579168, JInt, required = false, default = nil)
  if valid_579168 != nil:
    section.add "pageSize", valid_579168
  var valid_579169 = query.getOrDefault("alt")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = newJString("json"))
  if valid_579169 != nil:
    section.add "alt", valid_579169
  var valid_579170 = query.getOrDefault("uploadType")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "uploadType", valid_579170
  var valid_579171 = query.getOrDefault("quotaUser")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "quotaUser", valid_579171
  var valid_579172 = query.getOrDefault("type")
  valid_579172 = validateParameter(valid_579172, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_579172 != nil:
    section.add "type", valid_579172
  var valid_579173 = query.getOrDefault("filter")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "filter", valid_579173
  var valid_579174 = query.getOrDefault("pageToken")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "pageToken", valid_579174
  var valid_579175 = query.getOrDefault("callback")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "callback", valid_579175
  var valid_579176 = query.getOrDefault("fields")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "fields", valid_579176
  var valid_579177 = query.getOrDefault("access_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "access_token", valid_579177
  var valid_579178 = query.getOrDefault("upload_protocol")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "upload_protocol", valid_579178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579179: Call_DlpProjectsDlpJobsList_579158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## 
  let valid = call_579179.validator(path, query, header, formData, body)
  let scheme = call_579179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579179.url(scheme.get, call_579179.host, call_579179.base,
                         call_579179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579179, url, valid)

proc call*(call_579180: Call_DlpProjectsDlpJobsList_579158; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; `type`: string = "DLP_JOB_TYPE_UNSPECIFIED";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsList
  ## Lists DlpJobs that match the specified filter in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   type: string
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
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
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579181 = newJObject()
  var query_579182 = newJObject()
  add(query_579182, "key", newJString(key))
  add(query_579182, "pp", newJBool(pp))
  add(query_579182, "prettyPrint", newJBool(prettyPrint))
  add(query_579182, "oauth_token", newJString(oauthToken))
  add(query_579182, "$.xgafv", newJString(Xgafv))
  add(query_579182, "bearer_token", newJString(bearerToken))
  add(query_579182, "pageSize", newJInt(pageSize))
  add(query_579182, "alt", newJString(alt))
  add(query_579182, "uploadType", newJString(uploadType))
  add(query_579182, "quotaUser", newJString(quotaUser))
  add(query_579182, "type", newJString(`type`))
  add(query_579182, "filter", newJString(filter))
  add(query_579182, "pageToken", newJString(pageToken))
  add(query_579182, "callback", newJString(callback))
  add(path_579181, "parent", newJString(parent))
  add(query_579182, "fields", newJString(fields))
  add(query_579182, "access_token", newJString(accessToken))
  add(query_579182, "upload_protocol", newJString(uploadProtocol))
  result = call_579180.call(path_579181, query_579182, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_579158(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_579159, base: "/",
    url: url_DlpProjectsDlpJobsList_579160, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_579183 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsImageRedact_579185(protocol: Scheme; host: string; base: string;
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

proc validate_DlpProjectsImageRedact_579184(path: JsonNode; query: JsonNode;
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
  var valid_579186 = path.getOrDefault("parent")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "parent", valid_579186
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579187 = query.getOrDefault("key")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "key", valid_579187
  var valid_579188 = query.getOrDefault("pp")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(true))
  if valid_579188 != nil:
    section.add "pp", valid_579188
  var valid_579189 = query.getOrDefault("prettyPrint")
  valid_579189 = validateParameter(valid_579189, JBool, required = false,
                                 default = newJBool(true))
  if valid_579189 != nil:
    section.add "prettyPrint", valid_579189
  var valid_579190 = query.getOrDefault("oauth_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "oauth_token", valid_579190
  var valid_579191 = query.getOrDefault("$.xgafv")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = newJString("1"))
  if valid_579191 != nil:
    section.add "$.xgafv", valid_579191
  var valid_579192 = query.getOrDefault("bearer_token")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "bearer_token", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("uploadType")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "uploadType", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("callback")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "callback", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
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

proc call*(call_579201: Call_DlpProjectsImageRedact_579183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_DlpProjectsImageRedact_579183; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  var body_579205 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "pp", newJBool(pp))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "$.xgafv", newJString(Xgafv))
  add(query_579204, "bearer_token", newJString(bearerToken))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "uploadType", newJString(uploadType))
  add(query_579204, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579205 = body
  add(query_579204, "callback", newJString(callback))
  add(path_579203, "parent", newJString(parent))
  add(query_579204, "fields", newJString(fields))
  add(query_579204, "access_token", newJString(accessToken))
  add(query_579204, "upload_protocol", newJString(uploadProtocol))
  result = call_579202.call(path_579203, query_579204, nil, nil, body_579205)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_579183(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_579184, base: "/",
    url: url_DlpProjectsImageRedact_579185, schemes: {Scheme.Https})
type
  Call_DlpProjectsInspectTemplatesCreate_579229 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsInspectTemplatesCreate_579231(protocol: Scheme; host: string;
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

proc validate_DlpProjectsInspectTemplatesCreate_579230(path: JsonNode;
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
  var valid_579232 = path.getOrDefault("parent")
  valid_579232 = validateParameter(valid_579232, JString, required = true,
                                 default = nil)
  if valid_579232 != nil:
    section.add "parent", valid_579232
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579233 = query.getOrDefault("key")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "key", valid_579233
  var valid_579234 = query.getOrDefault("pp")
  valid_579234 = validateParameter(valid_579234, JBool, required = false,
                                 default = newJBool(true))
  if valid_579234 != nil:
    section.add "pp", valid_579234
  var valid_579235 = query.getOrDefault("prettyPrint")
  valid_579235 = validateParameter(valid_579235, JBool, required = false,
                                 default = newJBool(true))
  if valid_579235 != nil:
    section.add "prettyPrint", valid_579235
  var valid_579236 = query.getOrDefault("oauth_token")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "oauth_token", valid_579236
  var valid_579237 = query.getOrDefault("$.xgafv")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = newJString("1"))
  if valid_579237 != nil:
    section.add "$.xgafv", valid_579237
  var valid_579238 = query.getOrDefault("bearer_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "bearer_token", valid_579238
  var valid_579239 = query.getOrDefault("alt")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("json"))
  if valid_579239 != nil:
    section.add "alt", valid_579239
  var valid_579240 = query.getOrDefault("uploadType")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "uploadType", valid_579240
  var valid_579241 = query.getOrDefault("quotaUser")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "quotaUser", valid_579241
  var valid_579242 = query.getOrDefault("callback")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "callback", valid_579242
  var valid_579243 = query.getOrDefault("fields")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "fields", valid_579243
  var valid_579244 = query.getOrDefault("access_token")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "access_token", valid_579244
  var valid_579245 = query.getOrDefault("upload_protocol")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "upload_protocol", valid_579245
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

proc call*(call_579247: Call_DlpProjectsInspectTemplatesCreate_579229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## 
  let valid = call_579247.validator(path, query, header, formData, body)
  let scheme = call_579247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579247.url(scheme.get, call_579247.host, call_579247.base,
                         call_579247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579247, url, valid)

proc call*(call_579248: Call_DlpProjectsInspectTemplatesCreate_579229;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsInspectTemplatesCreate
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579249 = newJObject()
  var query_579250 = newJObject()
  var body_579251 = newJObject()
  add(query_579250, "key", newJString(key))
  add(query_579250, "pp", newJBool(pp))
  add(query_579250, "prettyPrint", newJBool(prettyPrint))
  add(query_579250, "oauth_token", newJString(oauthToken))
  add(query_579250, "$.xgafv", newJString(Xgafv))
  add(query_579250, "bearer_token", newJString(bearerToken))
  add(query_579250, "alt", newJString(alt))
  add(query_579250, "uploadType", newJString(uploadType))
  add(query_579250, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579251 = body
  add(query_579250, "callback", newJString(callback))
  add(path_579249, "parent", newJString(parent))
  add(query_579250, "fields", newJString(fields))
  add(query_579250, "access_token", newJString(accessToken))
  add(query_579250, "upload_protocol", newJString(uploadProtocol))
  result = call_579248.call(path_579249, query_579250, nil, nil, body_579251)

var dlpProjectsInspectTemplatesCreate* = Call_DlpProjectsInspectTemplatesCreate_579229(
    name: "dlpProjectsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/inspectTemplates",
    validator: validate_DlpProjectsInspectTemplatesCreate_579230, base: "/",
    url: url_DlpProjectsInspectTemplatesCreate_579231, schemes: {Scheme.Https})
type
  Call_DlpProjectsInspectTemplatesList_579206 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsInspectTemplatesList_579208(protocol: Scheme; host: string;
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

proc validate_DlpProjectsInspectTemplatesList_579207(path: JsonNode;
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
  var valid_579209 = path.getOrDefault("parent")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "parent", valid_579209
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579210 = query.getOrDefault("key")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "key", valid_579210
  var valid_579211 = query.getOrDefault("pp")
  valid_579211 = validateParameter(valid_579211, JBool, required = false,
                                 default = newJBool(true))
  if valid_579211 != nil:
    section.add "pp", valid_579211
  var valid_579212 = query.getOrDefault("prettyPrint")
  valid_579212 = validateParameter(valid_579212, JBool, required = false,
                                 default = newJBool(true))
  if valid_579212 != nil:
    section.add "prettyPrint", valid_579212
  var valid_579213 = query.getOrDefault("oauth_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "oauth_token", valid_579213
  var valid_579214 = query.getOrDefault("$.xgafv")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("1"))
  if valid_579214 != nil:
    section.add "$.xgafv", valid_579214
  var valid_579215 = query.getOrDefault("bearer_token")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "bearer_token", valid_579215
  var valid_579216 = query.getOrDefault("pageSize")
  valid_579216 = validateParameter(valid_579216, JInt, required = false, default = nil)
  if valid_579216 != nil:
    section.add "pageSize", valid_579216
  var valid_579217 = query.getOrDefault("alt")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = newJString("json"))
  if valid_579217 != nil:
    section.add "alt", valid_579217
  var valid_579218 = query.getOrDefault("uploadType")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "uploadType", valid_579218
  var valid_579219 = query.getOrDefault("quotaUser")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "quotaUser", valid_579219
  var valid_579220 = query.getOrDefault("pageToken")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "pageToken", valid_579220
  var valid_579221 = query.getOrDefault("callback")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "callback", valid_579221
  var valid_579222 = query.getOrDefault("fields")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "fields", valid_579222
  var valid_579223 = query.getOrDefault("access_token")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "access_token", valid_579223
  var valid_579224 = query.getOrDefault("upload_protocol")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "upload_protocol", valid_579224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579225: Call_DlpProjectsInspectTemplatesList_579206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists inspect templates.
  ## 
  let valid = call_579225.validator(path, query, header, formData, body)
  let scheme = call_579225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579225.url(scheme.get, call_579225.host, call_579225.base,
                         call_579225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579225, url, valid)

proc call*(call_579226: Call_DlpProjectsInspectTemplatesList_579206;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsInspectTemplatesList
  ## Lists inspect templates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579227 = newJObject()
  var query_579228 = newJObject()
  add(query_579228, "key", newJString(key))
  add(query_579228, "pp", newJBool(pp))
  add(query_579228, "prettyPrint", newJBool(prettyPrint))
  add(query_579228, "oauth_token", newJString(oauthToken))
  add(query_579228, "$.xgafv", newJString(Xgafv))
  add(query_579228, "bearer_token", newJString(bearerToken))
  add(query_579228, "pageSize", newJInt(pageSize))
  add(query_579228, "alt", newJString(alt))
  add(query_579228, "uploadType", newJString(uploadType))
  add(query_579228, "quotaUser", newJString(quotaUser))
  add(query_579228, "pageToken", newJString(pageToken))
  add(query_579228, "callback", newJString(callback))
  add(path_579227, "parent", newJString(parent))
  add(query_579228, "fields", newJString(fields))
  add(query_579228, "access_token", newJString(accessToken))
  add(query_579228, "upload_protocol", newJString(uploadProtocol))
  result = call_579226.call(path_579227, query_579228, nil, nil, nil)

var dlpProjectsInspectTemplatesList* = Call_DlpProjectsInspectTemplatesList_579206(
    name: "dlpProjectsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/inspectTemplates",
    validator: validate_DlpProjectsInspectTemplatesList_579207, base: "/",
    url: url_DlpProjectsInspectTemplatesList_579208, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_579276 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersCreate_579278(protocol: Scheme; host: string;
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

proc validate_DlpProjectsJobTriggersCreate_579277(path: JsonNode; query: JsonNode;
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
  var valid_579279 = path.getOrDefault("parent")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "parent", valid_579279
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579280 = query.getOrDefault("key")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "key", valid_579280
  var valid_579281 = query.getOrDefault("pp")
  valid_579281 = validateParameter(valid_579281, JBool, required = false,
                                 default = newJBool(true))
  if valid_579281 != nil:
    section.add "pp", valid_579281
  var valid_579282 = query.getOrDefault("prettyPrint")
  valid_579282 = validateParameter(valid_579282, JBool, required = false,
                                 default = newJBool(true))
  if valid_579282 != nil:
    section.add "prettyPrint", valid_579282
  var valid_579283 = query.getOrDefault("oauth_token")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "oauth_token", valid_579283
  var valid_579284 = query.getOrDefault("$.xgafv")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = newJString("1"))
  if valid_579284 != nil:
    section.add "$.xgafv", valid_579284
  var valid_579285 = query.getOrDefault("bearer_token")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "bearer_token", valid_579285
  var valid_579286 = query.getOrDefault("alt")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = newJString("json"))
  if valid_579286 != nil:
    section.add "alt", valid_579286
  var valid_579287 = query.getOrDefault("uploadType")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "uploadType", valid_579287
  var valid_579288 = query.getOrDefault("quotaUser")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "quotaUser", valid_579288
  var valid_579289 = query.getOrDefault("callback")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "callback", valid_579289
  var valid_579290 = query.getOrDefault("fields")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "fields", valid_579290
  var valid_579291 = query.getOrDefault("access_token")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "access_token", valid_579291
  var valid_579292 = query.getOrDefault("upload_protocol")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "upload_protocol", valid_579292
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

proc call*(call_579294: Call_DlpProjectsJobTriggersCreate_579276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ## 
  let valid = call_579294.validator(path, query, header, formData, body)
  let scheme = call_579294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579294.url(scheme.get, call_579294.host, call_579294.base,
                         call_579294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579294, url, valid)

proc call*(call_579295: Call_DlpProjectsJobTriggersCreate_579276; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersCreate
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579296 = newJObject()
  var query_579297 = newJObject()
  var body_579298 = newJObject()
  add(query_579297, "key", newJString(key))
  add(query_579297, "pp", newJBool(pp))
  add(query_579297, "prettyPrint", newJBool(prettyPrint))
  add(query_579297, "oauth_token", newJString(oauthToken))
  add(query_579297, "$.xgafv", newJString(Xgafv))
  add(query_579297, "bearer_token", newJString(bearerToken))
  add(query_579297, "alt", newJString(alt))
  add(query_579297, "uploadType", newJString(uploadType))
  add(query_579297, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579298 = body
  add(query_579297, "callback", newJString(callback))
  add(path_579296, "parent", newJString(parent))
  add(query_579297, "fields", newJString(fields))
  add(query_579297, "access_token", newJString(accessToken))
  add(query_579297, "upload_protocol", newJString(uploadProtocol))
  result = call_579295.call(path_579296, query_579297, nil, nil, body_579298)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_579276(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_579277, base: "/",
    url: url_DlpProjectsJobTriggersCreate_579278, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_579252 = ref object of OpenApiRestCall_578348
proc url_DlpProjectsJobTriggersList_579254(protocol: Scheme; host: string;
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

proc validate_DlpProjectsJobTriggersList_579253(path: JsonNode; query: JsonNode;
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
  var valid_579255 = path.getOrDefault("parent")
  valid_579255 = validateParameter(valid_579255, JString, required = true,
                                 default = nil)
  if valid_579255 != nil:
    section.add "parent", valid_579255
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by a server.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` and `filter` should not change for
  ## subsequent calls, but can be omitted if token is specified.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579256 = query.getOrDefault("key")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "key", valid_579256
  var valid_579257 = query.getOrDefault("pp")
  valid_579257 = validateParameter(valid_579257, JBool, required = false,
                                 default = newJBool(true))
  if valid_579257 != nil:
    section.add "pp", valid_579257
  var valid_579258 = query.getOrDefault("prettyPrint")
  valid_579258 = validateParameter(valid_579258, JBool, required = false,
                                 default = newJBool(true))
  if valid_579258 != nil:
    section.add "prettyPrint", valid_579258
  var valid_579259 = query.getOrDefault("oauth_token")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "oauth_token", valid_579259
  var valid_579260 = query.getOrDefault("$.xgafv")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = newJString("1"))
  if valid_579260 != nil:
    section.add "$.xgafv", valid_579260
  var valid_579261 = query.getOrDefault("bearer_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "bearer_token", valid_579261
  var valid_579262 = query.getOrDefault("pageSize")
  valid_579262 = validateParameter(valid_579262, JInt, required = false, default = nil)
  if valid_579262 != nil:
    section.add "pageSize", valid_579262
  var valid_579263 = query.getOrDefault("alt")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = newJString("json"))
  if valid_579263 != nil:
    section.add "alt", valid_579263
  var valid_579264 = query.getOrDefault("uploadType")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "uploadType", valid_579264
  var valid_579265 = query.getOrDefault("quotaUser")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "quotaUser", valid_579265
  var valid_579266 = query.getOrDefault("orderBy")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "orderBy", valid_579266
  var valid_579267 = query.getOrDefault("pageToken")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "pageToken", valid_579267
  var valid_579268 = query.getOrDefault("callback")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "callback", valid_579268
  var valid_579269 = query.getOrDefault("fields")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "fields", valid_579269
  var valid_579270 = query.getOrDefault("access_token")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "access_token", valid_579270
  var valid_579271 = query.getOrDefault("upload_protocol")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "upload_protocol", valid_579271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579272: Call_DlpProjectsJobTriggersList_579252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## 
  let valid = call_579272.validator(path, query, header, formData, body)
  let scheme = call_579272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579272.url(scheme.get, call_579272.host, call_579272.base,
                         call_579272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579272, url, valid)

proc call*(call_579273: Call_DlpProjectsJobTriggersList_579252; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; orderBy: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersList
  ## Lists job triggers.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by a server.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` and `filter` should not change for
  ## subsequent calls, but can be omitted if token is specified.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579274 = newJObject()
  var query_579275 = newJObject()
  add(query_579275, "key", newJString(key))
  add(query_579275, "pp", newJBool(pp))
  add(query_579275, "prettyPrint", newJBool(prettyPrint))
  add(query_579275, "oauth_token", newJString(oauthToken))
  add(query_579275, "$.xgafv", newJString(Xgafv))
  add(query_579275, "bearer_token", newJString(bearerToken))
  add(query_579275, "pageSize", newJInt(pageSize))
  add(query_579275, "alt", newJString(alt))
  add(query_579275, "uploadType", newJString(uploadType))
  add(query_579275, "quotaUser", newJString(quotaUser))
  add(query_579275, "orderBy", newJString(orderBy))
  add(query_579275, "pageToken", newJString(pageToken))
  add(query_579275, "callback", newJString(callback))
  add(path_579274, "parent", newJString(parent))
  add(query_579275, "fields", newJString(fields))
  add(query_579275, "access_token", newJString(accessToken))
  add(query_579275, "upload_protocol", newJString(uploadProtocol))
  result = call_579273.call(path_579274, query_579275, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_579252(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_579253, base: "/",
    url: url_DlpProjectsJobTriggersList_579254, schemes: {Scheme.Https})
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
