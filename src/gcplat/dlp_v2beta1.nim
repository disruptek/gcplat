
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Data Loss Prevention (DLP)
## version: v2beta1
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
  Call_DlpContentDeidentify_578619 = ref object of OpenApiRestCall_578348
proc url_DlpContentDeidentify_578621(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpContentDeidentify_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a list of strings.
  ## This method has limits on input size and output size.
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
  ##   callback: JString
  ##           : JSONP
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
  var valid_578755 = query.getOrDefault("callback")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "callback", valid_578755
  var valid_578756 = query.getOrDefault("fields")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "fields", valid_578756
  var valid_578757 = query.getOrDefault("access_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "access_token", valid_578757
  var valid_578758 = query.getOrDefault("upload_protocol")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "upload_protocol", valid_578758
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

proc call*(call_578782: Call_DlpContentDeidentify_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a list of strings.
  ## This method has limits on input size and output size.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_DlpContentDeidentify_578619; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpContentDeidentify
  ## De-identifies potentially sensitive info from a list of strings.
  ## This method has limits on input size and output size.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578854 = newJObject()
  var body_578856 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "pp", newJBool(pp))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "$.xgafv", newJString(Xgafv))
  add(query_578854, "bearer_token", newJString(bearerToken))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "uploadType", newJString(uploadType))
  add(query_578854, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578856 = body
  add(query_578854, "callback", newJString(callback))
  add(query_578854, "fields", newJString(fields))
  add(query_578854, "access_token", newJString(accessToken))
  add(query_578854, "upload_protocol", newJString(uploadProtocol))
  result = call_578853.call(nil, query_578854, nil, nil, body_578856)

var dlpContentDeidentify* = Call_DlpContentDeidentify_578619(
    name: "dlpContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/content:deidentify",
    validator: validate_DlpContentDeidentify_578620, base: "/",
    url: url_DlpContentDeidentify_578621, schemes: {Scheme.Https})
type
  Call_DlpContentInspect_578895 = ref object of OpenApiRestCall_578348
proc url_DlpContentInspect_578897(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpContentInspect_578896(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in a list of strings.
  ## This method has limits on input size, processing time, and output size.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578898 = query.getOrDefault("key")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "key", valid_578898
  var valid_578899 = query.getOrDefault("pp")
  valid_578899 = validateParameter(valid_578899, JBool, required = false,
                                 default = newJBool(true))
  if valid_578899 != nil:
    section.add "pp", valid_578899
  var valid_578900 = query.getOrDefault("prettyPrint")
  valid_578900 = validateParameter(valid_578900, JBool, required = false,
                                 default = newJBool(true))
  if valid_578900 != nil:
    section.add "prettyPrint", valid_578900
  var valid_578901 = query.getOrDefault("oauth_token")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "oauth_token", valid_578901
  var valid_578902 = query.getOrDefault("$.xgafv")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString("1"))
  if valid_578902 != nil:
    section.add "$.xgafv", valid_578902
  var valid_578903 = query.getOrDefault("bearer_token")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "bearer_token", valid_578903
  var valid_578904 = query.getOrDefault("alt")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = newJString("json"))
  if valid_578904 != nil:
    section.add "alt", valid_578904
  var valid_578905 = query.getOrDefault("uploadType")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "uploadType", valid_578905
  var valid_578906 = query.getOrDefault("quotaUser")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "quotaUser", valid_578906
  var valid_578907 = query.getOrDefault("callback")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "callback", valid_578907
  var valid_578908 = query.getOrDefault("fields")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "fields", valid_578908
  var valid_578909 = query.getOrDefault("access_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "access_token", valid_578909
  var valid_578910 = query.getOrDefault("upload_protocol")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "upload_protocol", valid_578910
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

proc call*(call_578912: Call_DlpContentInspect_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in a list of strings.
  ## This method has limits on input size, processing time, and output size.
  ## 
  let valid = call_578912.validator(path, query, header, formData, body)
  let scheme = call_578912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578912.url(scheme.get, call_578912.host, call_578912.base,
                         call_578912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578912, url, valid)

proc call*(call_578913: Call_DlpContentInspect_578895; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpContentInspect
  ## Finds potentially sensitive info in a list of strings.
  ## This method has limits on input size, processing time, and output size.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578914 = newJObject()
  var body_578915 = newJObject()
  add(query_578914, "key", newJString(key))
  add(query_578914, "pp", newJBool(pp))
  add(query_578914, "prettyPrint", newJBool(prettyPrint))
  add(query_578914, "oauth_token", newJString(oauthToken))
  add(query_578914, "$.xgafv", newJString(Xgafv))
  add(query_578914, "bearer_token", newJString(bearerToken))
  add(query_578914, "alt", newJString(alt))
  add(query_578914, "uploadType", newJString(uploadType))
  add(query_578914, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578915 = body
  add(query_578914, "callback", newJString(callback))
  add(query_578914, "fields", newJString(fields))
  add(query_578914, "access_token", newJString(accessToken))
  add(query_578914, "upload_protocol", newJString(uploadProtocol))
  result = call_578913.call(nil, query_578914, nil, nil, body_578915)

var dlpContentInspect* = Call_DlpContentInspect_578895(name: "dlpContentInspect",
    meth: HttpMethod.HttpPost, host: "dlp.googleapis.com",
    route: "/v2beta1/content:inspect", validator: validate_DlpContentInspect_578896,
    base: "/", url: url_DlpContentInspect_578897, schemes: {Scheme.Https})
type
  Call_DlpContentRedact_578916 = ref object of OpenApiRestCall_578348
proc url_DlpContentRedact_578918(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpContentRedact_578917(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Redacts potentially sensitive info from a list of strings.
  ## This method has limits on input size, processing time, and output size.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578919 = query.getOrDefault("key")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "key", valid_578919
  var valid_578920 = query.getOrDefault("pp")
  valid_578920 = validateParameter(valid_578920, JBool, required = false,
                                 default = newJBool(true))
  if valid_578920 != nil:
    section.add "pp", valid_578920
  var valid_578921 = query.getOrDefault("prettyPrint")
  valid_578921 = validateParameter(valid_578921, JBool, required = false,
                                 default = newJBool(true))
  if valid_578921 != nil:
    section.add "prettyPrint", valid_578921
  var valid_578922 = query.getOrDefault("oauth_token")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "oauth_token", valid_578922
  var valid_578923 = query.getOrDefault("$.xgafv")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = newJString("1"))
  if valid_578923 != nil:
    section.add "$.xgafv", valid_578923
  var valid_578924 = query.getOrDefault("bearer_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "bearer_token", valid_578924
  var valid_578925 = query.getOrDefault("alt")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("json"))
  if valid_578925 != nil:
    section.add "alt", valid_578925
  var valid_578926 = query.getOrDefault("uploadType")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "uploadType", valid_578926
  var valid_578927 = query.getOrDefault("quotaUser")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "quotaUser", valid_578927
  var valid_578928 = query.getOrDefault("callback")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "callback", valid_578928
  var valid_578929 = query.getOrDefault("fields")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "fields", valid_578929
  var valid_578930 = query.getOrDefault("access_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "access_token", valid_578930
  var valid_578931 = query.getOrDefault("upload_protocol")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "upload_protocol", valid_578931
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

proc call*(call_578933: Call_DlpContentRedact_578916; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from a list of strings.
  ## This method has limits on input size, processing time, and output size.
  ## 
  let valid = call_578933.validator(path, query, header, formData, body)
  let scheme = call_578933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578933.url(scheme.get, call_578933.host, call_578933.base,
                         call_578933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578933, url, valid)

proc call*(call_578934: Call_DlpContentRedact_578916; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpContentRedact
  ## Redacts potentially sensitive info from a list of strings.
  ## This method has limits on input size, processing time, and output size.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578935 = newJObject()
  var body_578936 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "pp", newJBool(pp))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(query_578935, "$.xgafv", newJString(Xgafv))
  add(query_578935, "bearer_token", newJString(bearerToken))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "uploadType", newJString(uploadType))
  add(query_578935, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578936 = body
  add(query_578935, "callback", newJString(callback))
  add(query_578935, "fields", newJString(fields))
  add(query_578935, "access_token", newJString(accessToken))
  add(query_578935, "upload_protocol", newJString(uploadProtocol))
  result = call_578934.call(nil, query_578935, nil, nil, body_578936)

var dlpContentRedact* = Call_DlpContentRedact_578916(name: "dlpContentRedact",
    meth: HttpMethod.HttpPost, host: "dlp.googleapis.com",
    route: "/v2beta1/content:redact", validator: validate_DlpContentRedact_578917,
    base: "/", url: url_DlpContentRedact_578918, schemes: {Scheme.Https})
type
  Call_DlpDataSourceAnalyze_578937 = ref object of OpenApiRestCall_578348
proc url_DlpDataSourceAnalyze_578939(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpDataSourceAnalyze_578938(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578940 = query.getOrDefault("key")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "key", valid_578940
  var valid_578941 = query.getOrDefault("pp")
  valid_578941 = validateParameter(valid_578941, JBool, required = false,
                                 default = newJBool(true))
  if valid_578941 != nil:
    section.add "pp", valid_578941
  var valid_578942 = query.getOrDefault("prettyPrint")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(true))
  if valid_578942 != nil:
    section.add "prettyPrint", valid_578942
  var valid_578943 = query.getOrDefault("oauth_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "oauth_token", valid_578943
  var valid_578944 = query.getOrDefault("$.xgafv")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("1"))
  if valid_578944 != nil:
    section.add "$.xgafv", valid_578944
  var valid_578945 = query.getOrDefault("bearer_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "bearer_token", valid_578945
  var valid_578946 = query.getOrDefault("alt")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("json"))
  if valid_578946 != nil:
    section.add "alt", valid_578946
  var valid_578947 = query.getOrDefault("uploadType")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "uploadType", valid_578947
  var valid_578948 = query.getOrDefault("quotaUser")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "quotaUser", valid_578948
  var valid_578949 = query.getOrDefault("callback")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "callback", valid_578949
  var valid_578950 = query.getOrDefault("fields")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "fields", valid_578950
  var valid_578951 = query.getOrDefault("access_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "access_token", valid_578951
  var valid_578952 = query.getOrDefault("upload_protocol")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "upload_protocol", valid_578952
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

proc call*(call_578954: Call_DlpDataSourceAnalyze_578937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository.
  ## 
  let valid = call_578954.validator(path, query, header, formData, body)
  let scheme = call_578954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578954.url(scheme.get, call_578954.host, call_578954.base,
                         call_578954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578954, url, valid)

proc call*(call_578955: Call_DlpDataSourceAnalyze_578937; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpDataSourceAnalyze
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578956 = newJObject()
  var body_578957 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "pp", newJBool(pp))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "$.xgafv", newJString(Xgafv))
  add(query_578956, "bearer_token", newJString(bearerToken))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "uploadType", newJString(uploadType))
  add(query_578956, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578957 = body
  add(query_578956, "callback", newJString(callback))
  add(query_578956, "fields", newJString(fields))
  add(query_578956, "access_token", newJString(accessToken))
  add(query_578956, "upload_protocol", newJString(uploadProtocol))
  result = call_578955.call(nil, query_578956, nil, nil, body_578957)

var dlpDataSourceAnalyze* = Call_DlpDataSourceAnalyze_578937(
    name: "dlpDataSourceAnalyze", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/dataSource:analyze",
    validator: validate_DlpDataSourceAnalyze_578938, base: "/",
    url: url_DlpDataSourceAnalyze_578939, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsCreate_578958 = ref object of OpenApiRestCall_578348
proc url_DlpInspectOperationsCreate_578960(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpInspectOperationsCreate_578959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578961 = query.getOrDefault("key")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "key", valid_578961
  var valid_578962 = query.getOrDefault("pp")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(true))
  if valid_578962 != nil:
    section.add "pp", valid_578962
  var valid_578963 = query.getOrDefault("prettyPrint")
  valid_578963 = validateParameter(valid_578963, JBool, required = false,
                                 default = newJBool(true))
  if valid_578963 != nil:
    section.add "prettyPrint", valid_578963
  var valid_578964 = query.getOrDefault("oauth_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "oauth_token", valid_578964
  var valid_578965 = query.getOrDefault("$.xgafv")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("1"))
  if valid_578965 != nil:
    section.add "$.xgafv", valid_578965
  var valid_578966 = query.getOrDefault("bearer_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "bearer_token", valid_578966
  var valid_578967 = query.getOrDefault("alt")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("json"))
  if valid_578967 != nil:
    section.add "alt", valid_578967
  var valid_578968 = query.getOrDefault("uploadType")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "uploadType", valid_578968
  var valid_578969 = query.getOrDefault("quotaUser")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "quotaUser", valid_578969
  var valid_578970 = query.getOrDefault("callback")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "callback", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
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

proc call*(call_578975: Call_DlpInspectOperationsCreate_578958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_DlpInspectOperationsCreate_578958; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpInspectOperationsCreate
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578977 = newJObject()
  var body_578978 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "pp", newJBool(pp))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "$.xgafv", newJString(Xgafv))
  add(query_578977, "bearer_token", newJString(bearerToken))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "uploadType", newJString(uploadType))
  add(query_578977, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578978 = body
  add(query_578977, "callback", newJString(callback))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "access_token", newJString(accessToken))
  add(query_578977, "upload_protocol", newJString(uploadProtocol))
  result = call_578976.call(nil, query_578977, nil, nil, body_578978)

var dlpInspectOperationsCreate* = Call_DlpInspectOperationsCreate_578958(
    name: "dlpInspectOperationsCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/inspect/operations",
    validator: validate_DlpInspectOperationsCreate_578959, base: "/",
    url: url_DlpInspectOperationsCreate_578960, schemes: {Scheme.Https})
type
  Call_DlpRootCategoriesList_578979 = ref object of OpenApiRestCall_578348
proc url_DlpRootCategoriesList_578981(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpRootCategoriesList_578980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of root categories of sensitive information.
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
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional language code for localized friendly category names.
  ## If omitted or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("pp")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "pp", valid_578983
  var valid_578984 = query.getOrDefault("prettyPrint")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(true))
  if valid_578984 != nil:
    section.add "prettyPrint", valid_578984
  var valid_578985 = query.getOrDefault("oauth_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "oauth_token", valid_578985
  var valid_578986 = query.getOrDefault("$.xgafv")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("1"))
  if valid_578986 != nil:
    section.add "$.xgafv", valid_578986
  var valid_578987 = query.getOrDefault("bearer_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "bearer_token", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("uploadType")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "uploadType", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("callback")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "callback", valid_578991
  var valid_578992 = query.getOrDefault("languageCode")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "languageCode", valid_578992
  var valid_578993 = query.getOrDefault("fields")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "fields", valid_578993
  var valid_578994 = query.getOrDefault("access_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "access_token", valid_578994
  var valid_578995 = query.getOrDefault("upload_protocol")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "upload_protocol", valid_578995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578996: Call_DlpRootCategoriesList_578979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of root categories of sensitive information.
  ## 
  let valid = call_578996.validator(path, query, header, formData, body)
  let scheme = call_578996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578996.url(scheme.get, call_578996.host, call_578996.base,
                         call_578996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578996, url, valid)

proc call*(call_578997: Call_DlpRootCategoriesList_578979; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          languageCode: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpRootCategoriesList
  ## Returns the list of root categories of sensitive information.
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
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional language code for localized friendly category names.
  ## If omitted or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578998 = newJObject()
  add(query_578998, "key", newJString(key))
  add(query_578998, "pp", newJBool(pp))
  add(query_578998, "prettyPrint", newJBool(prettyPrint))
  add(query_578998, "oauth_token", newJString(oauthToken))
  add(query_578998, "$.xgafv", newJString(Xgafv))
  add(query_578998, "bearer_token", newJString(bearerToken))
  add(query_578998, "alt", newJString(alt))
  add(query_578998, "uploadType", newJString(uploadType))
  add(query_578998, "quotaUser", newJString(quotaUser))
  add(query_578998, "callback", newJString(callback))
  add(query_578998, "languageCode", newJString(languageCode))
  add(query_578998, "fields", newJString(fields))
  add(query_578998, "access_token", newJString(accessToken))
  add(query_578998, "upload_protocol", newJString(uploadProtocol))
  result = call_578997.call(nil, query_578998, nil, nil, nil)

var dlpRootCategoriesList* = Call_DlpRootCategoriesList_578979(
    name: "dlpRootCategoriesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta1/rootCategories",
    validator: validate_DlpRootCategoriesList_578980, base: "/",
    url: url_DlpRootCategoriesList_578981, schemes: {Scheme.Https})
type
  Call_DlpRootCategoriesInfoTypesList_578999 = ref object of OpenApiRestCall_578348
proc url_DlpRootCategoriesInfoTypesList_579001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "category" in path, "`category` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/rootCategories/"),
               (kind: VariableSegment, value: "category"),
               (kind: ConstantSegment, value: "/infoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpRootCategoriesInfoTypesList_579000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns sensitive information types for given category.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   category: JString (required)
  ##           : Category name as returned by ListRootCategories.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `category` field"
  var valid_579016 = path.getOrDefault("category")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "category", valid_579016
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
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized info type friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("pp")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "pp", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("$.xgafv")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("1"))
  if valid_579021 != nil:
    section.add "$.xgafv", valid_579021
  var valid_579022 = query.getOrDefault("bearer_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "bearer_token", valid_579022
  var valid_579023 = query.getOrDefault("alt")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("json"))
  if valid_579023 != nil:
    section.add "alt", valid_579023
  var valid_579024 = query.getOrDefault("uploadType")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "uploadType", valid_579024
  var valid_579025 = query.getOrDefault("quotaUser")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "quotaUser", valid_579025
  var valid_579026 = query.getOrDefault("callback")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "callback", valid_579026
  var valid_579027 = query.getOrDefault("languageCode")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "languageCode", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
  var valid_579029 = query.getOrDefault("access_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "access_token", valid_579029
  var valid_579030 = query.getOrDefault("upload_protocol")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "upload_protocol", valid_579030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579031: Call_DlpRootCategoriesInfoTypesList_578999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns sensitive information types for given category.
  ## 
  let valid = call_579031.validator(path, query, header, formData, body)
  let scheme = call_579031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579031.url(scheme.get, call_579031.host, call_579031.base,
                         call_579031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579031, url, valid)

proc call*(call_579032: Call_DlpRootCategoriesInfoTypesList_578999;
          category: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpRootCategoriesInfoTypesList
  ## Returns sensitive information types for given category.
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
  ##   category: string (required)
  ##           : Category name as returned by ListRootCategories.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized info type friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579033 = newJObject()
  var query_579034 = newJObject()
  add(query_579034, "key", newJString(key))
  add(query_579034, "pp", newJBool(pp))
  add(query_579034, "prettyPrint", newJBool(prettyPrint))
  add(query_579034, "oauth_token", newJString(oauthToken))
  add(query_579034, "$.xgafv", newJString(Xgafv))
  add(query_579034, "bearer_token", newJString(bearerToken))
  add(query_579034, "alt", newJString(alt))
  add(query_579034, "uploadType", newJString(uploadType))
  add(query_579034, "quotaUser", newJString(quotaUser))
  add(path_579033, "category", newJString(category))
  add(query_579034, "callback", newJString(callback))
  add(query_579034, "languageCode", newJString(languageCode))
  add(query_579034, "fields", newJString(fields))
  add(query_579034, "access_token", newJString(accessToken))
  add(query_579034, "upload_protocol", newJString(uploadProtocol))
  result = call_579032.call(path_579033, query_579034, nil, nil, nil)

var dlpRootCategoriesInfoTypesList* = Call_DlpRootCategoriesInfoTypesList_578999(
    name: "dlpRootCategoriesInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com",
    route: "/v2beta1/rootCategories/{category}/infoTypes",
    validator: validate_DlpRootCategoriesInfoTypesList_579000, base: "/",
    url: url_DlpRootCategoriesInfoTypesList_579001, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsGet_579035 = ref object of OpenApiRestCall_578348
proc url_DlpInspectOperationsGet_579037(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpInspectOperationsGet_579036(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579038 = path.getOrDefault("name")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "name", valid_579038
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
  var valid_579039 = query.getOrDefault("key")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "key", valid_579039
  var valid_579040 = query.getOrDefault("pp")
  valid_579040 = validateParameter(valid_579040, JBool, required = false,
                                 default = newJBool(true))
  if valid_579040 != nil:
    section.add "pp", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("$.xgafv")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("1"))
  if valid_579043 != nil:
    section.add "$.xgafv", valid_579043
  var valid_579044 = query.getOrDefault("bearer_token")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "bearer_token", valid_579044
  var valid_579045 = query.getOrDefault("alt")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = newJString("json"))
  if valid_579045 != nil:
    section.add "alt", valid_579045
  var valid_579046 = query.getOrDefault("uploadType")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "uploadType", valid_579046
  var valid_579047 = query.getOrDefault("quotaUser")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "quotaUser", valid_579047
  var valid_579048 = query.getOrDefault("callback")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "callback", valid_579048
  var valid_579049 = query.getOrDefault("fields")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "fields", valid_579049
  var valid_579050 = query.getOrDefault("access_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "access_token", valid_579050
  var valid_579051 = query.getOrDefault("upload_protocol")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "upload_protocol", valid_579051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579052: Call_DlpInspectOperationsGet_579035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579052.validator(path, query, header, formData, body)
  let scheme = call_579052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579052.url(scheme.get, call_579052.host, call_579052.base,
                         call_579052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579052, url, valid)

proc call*(call_579053: Call_DlpInspectOperationsGet_579035; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpInspectOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579054 = newJObject()
  var query_579055 = newJObject()
  add(query_579055, "key", newJString(key))
  add(query_579055, "pp", newJBool(pp))
  add(query_579055, "prettyPrint", newJBool(prettyPrint))
  add(query_579055, "oauth_token", newJString(oauthToken))
  add(query_579055, "$.xgafv", newJString(Xgafv))
  add(query_579055, "bearer_token", newJString(bearerToken))
  add(query_579055, "alt", newJString(alt))
  add(query_579055, "uploadType", newJString(uploadType))
  add(query_579055, "quotaUser", newJString(quotaUser))
  add(path_579054, "name", newJString(name))
  add(query_579055, "callback", newJString(callback))
  add(query_579055, "fields", newJString(fields))
  add(query_579055, "access_token", newJString(accessToken))
  add(query_579055, "upload_protocol", newJString(uploadProtocol))
  result = call_579053.call(path_579054, query_579055, nil, nil, nil)

var dlpInspectOperationsGet* = Call_DlpInspectOperationsGet_579035(
    name: "dlpInspectOperationsGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}",
    validator: validate_DlpInspectOperationsGet_579036, base: "/",
    url: url_DlpInspectOperationsGet_579037, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsDelete_579056 = ref object of OpenApiRestCall_578348
proc url_DlpInspectOperationsDelete_579058(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpInspectOperationsDelete_579057(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579059 = path.getOrDefault("name")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "name", valid_579059
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
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("pp")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "pp", valid_579061
  var valid_579062 = query.getOrDefault("prettyPrint")
  valid_579062 = validateParameter(valid_579062, JBool, required = false,
                                 default = newJBool(true))
  if valid_579062 != nil:
    section.add "prettyPrint", valid_579062
  var valid_579063 = query.getOrDefault("oauth_token")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "oauth_token", valid_579063
  var valid_579064 = query.getOrDefault("$.xgafv")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("1"))
  if valid_579064 != nil:
    section.add "$.xgafv", valid_579064
  var valid_579065 = query.getOrDefault("bearer_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "bearer_token", valid_579065
  var valid_579066 = query.getOrDefault("alt")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = newJString("json"))
  if valid_579066 != nil:
    section.add "alt", valid_579066
  var valid_579067 = query.getOrDefault("uploadType")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "uploadType", valid_579067
  var valid_579068 = query.getOrDefault("quotaUser")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "quotaUser", valid_579068
  var valid_579069 = query.getOrDefault("callback")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "callback", valid_579069
  var valid_579070 = query.getOrDefault("fields")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "fields", valid_579070
  var valid_579071 = query.getOrDefault("access_token")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "access_token", valid_579071
  var valid_579072 = query.getOrDefault("upload_protocol")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "upload_protocol", valid_579072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579073: Call_DlpInspectOperationsDelete_579056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ## 
  let valid = call_579073.validator(path, query, header, formData, body)
  let scheme = call_579073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579073.url(scheme.get, call_579073.host, call_579073.base,
                         call_579073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579073, url, valid)

proc call*(call_579074: Call_DlpInspectOperationsDelete_579056; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpInspectOperationsDelete
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
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
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579075 = newJObject()
  var query_579076 = newJObject()
  add(query_579076, "key", newJString(key))
  add(query_579076, "pp", newJBool(pp))
  add(query_579076, "prettyPrint", newJBool(prettyPrint))
  add(query_579076, "oauth_token", newJString(oauthToken))
  add(query_579076, "$.xgafv", newJString(Xgafv))
  add(query_579076, "bearer_token", newJString(bearerToken))
  add(query_579076, "alt", newJString(alt))
  add(query_579076, "uploadType", newJString(uploadType))
  add(query_579076, "quotaUser", newJString(quotaUser))
  add(path_579075, "name", newJString(name))
  add(query_579076, "callback", newJString(callback))
  add(query_579076, "fields", newJString(fields))
  add(query_579076, "access_token", newJString(accessToken))
  add(query_579076, "upload_protocol", newJString(uploadProtocol))
  result = call_579074.call(path_579075, query_579076, nil, nil, nil)

var dlpInspectOperationsDelete* = Call_DlpInspectOperationsDelete_579056(
    name: "dlpInspectOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}",
    validator: validate_DlpInspectOperationsDelete_579057, base: "/",
    url: url_DlpInspectOperationsDelete_579058, schemes: {Scheme.Https})
type
  Call_DlpInspectResultsFindingsList_579077 = ref object of OpenApiRestCall_578348
proc url_DlpInspectResultsFindingsList_579079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpInspectResultsFindingsList_579078(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of results for given inspect operation result set id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Identifier of the results set returned as metadata of
  ## the longrunning operation created by a call to InspectDataSource.
  ## Should be in the format of `inspect/results/{id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579080 = path.getOrDefault("name")
  valid_579080 = validateParameter(valid_579080, JString, required = true,
                                 default = nil)
  if valid_579080 != nil:
    section.add "name", valid_579080
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
  ##           : Maximum number of results to return.
  ## If 0, the implementation selects a reasonable value.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Restricts findings to items that match. Supports info_type and likelihood.
  ## 
  ## Examples:
  ## 
  ## - info_type=EMAIL_ADDRESS
  ## - info_type=PHONE_NUMBER,EMAIL_ADDRESS
  ## - likelihood=VERY_LIKELY
  ## - likelihood=VERY_LIKELY,LIKELY
  ## - info_type=EMAIL_ADDRESS,likelihood=VERY_LIKELY,LIKELY
  ##   pageToken: JString
  ##            : The value returned by the last `ListInspectFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListInspectFindings` call, and that
  ## the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579081 = query.getOrDefault("key")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "key", valid_579081
  var valid_579082 = query.getOrDefault("pp")
  valid_579082 = validateParameter(valid_579082, JBool, required = false,
                                 default = newJBool(true))
  if valid_579082 != nil:
    section.add "pp", valid_579082
  var valid_579083 = query.getOrDefault("prettyPrint")
  valid_579083 = validateParameter(valid_579083, JBool, required = false,
                                 default = newJBool(true))
  if valid_579083 != nil:
    section.add "prettyPrint", valid_579083
  var valid_579084 = query.getOrDefault("oauth_token")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "oauth_token", valid_579084
  var valid_579085 = query.getOrDefault("$.xgafv")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = newJString("1"))
  if valid_579085 != nil:
    section.add "$.xgafv", valid_579085
  var valid_579086 = query.getOrDefault("bearer_token")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "bearer_token", valid_579086
  var valid_579087 = query.getOrDefault("pageSize")
  valid_579087 = validateParameter(valid_579087, JInt, required = false, default = nil)
  if valid_579087 != nil:
    section.add "pageSize", valid_579087
  var valid_579088 = query.getOrDefault("alt")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("json"))
  if valid_579088 != nil:
    section.add "alt", valid_579088
  var valid_579089 = query.getOrDefault("uploadType")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "uploadType", valid_579089
  var valid_579090 = query.getOrDefault("quotaUser")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "quotaUser", valid_579090
  var valid_579091 = query.getOrDefault("filter")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "filter", valid_579091
  var valid_579092 = query.getOrDefault("pageToken")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "pageToken", valid_579092
  var valid_579093 = query.getOrDefault("callback")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "callback", valid_579093
  var valid_579094 = query.getOrDefault("fields")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "fields", valid_579094
  var valid_579095 = query.getOrDefault("access_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "access_token", valid_579095
  var valid_579096 = query.getOrDefault("upload_protocol")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "upload_protocol", valid_579096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579097: Call_DlpInspectResultsFindingsList_579077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of results for given inspect operation result set id.
  ## 
  let valid = call_579097.validator(path, query, header, formData, body)
  let scheme = call_579097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579097.url(scheme.get, call_579097.host, call_579097.base,
                         call_579097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579097, url, valid)

proc call*(call_579098: Call_DlpInspectResultsFindingsList_579077; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpInspectResultsFindingsList
  ## Returns list of results for given inspect operation result set id.
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
  ##           : Maximum number of results to return.
  ## If 0, the implementation selects a reasonable value.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Identifier of the results set returned as metadata of
  ## the longrunning operation created by a call to InspectDataSource.
  ## Should be in the format of `inspect/results/{id}`.
  ##   filter: string
  ##         : Restricts findings to items that match. Supports info_type and likelihood.
  ## 
  ## Examples:
  ## 
  ## - info_type=EMAIL_ADDRESS
  ## - info_type=PHONE_NUMBER,EMAIL_ADDRESS
  ## - likelihood=VERY_LIKELY
  ## - likelihood=VERY_LIKELY,LIKELY
  ## - info_type=EMAIL_ADDRESS,likelihood=VERY_LIKELY,LIKELY
  ##   pageToken: string
  ##            : The value returned by the last `ListInspectFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListInspectFindings` call, and that
  ## the system should return the next page of data.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579099 = newJObject()
  var query_579100 = newJObject()
  add(query_579100, "key", newJString(key))
  add(query_579100, "pp", newJBool(pp))
  add(query_579100, "prettyPrint", newJBool(prettyPrint))
  add(query_579100, "oauth_token", newJString(oauthToken))
  add(query_579100, "$.xgafv", newJString(Xgafv))
  add(query_579100, "bearer_token", newJString(bearerToken))
  add(query_579100, "pageSize", newJInt(pageSize))
  add(query_579100, "alt", newJString(alt))
  add(query_579100, "uploadType", newJString(uploadType))
  add(query_579100, "quotaUser", newJString(quotaUser))
  add(path_579099, "name", newJString(name))
  add(query_579100, "filter", newJString(filter))
  add(query_579100, "pageToken", newJString(pageToken))
  add(query_579100, "callback", newJString(callback))
  add(query_579100, "fields", newJString(fields))
  add(query_579100, "access_token", newJString(accessToken))
  add(query_579100, "upload_protocol", newJString(uploadProtocol))
  result = call_579098.call(path_579099, query_579100, nil, nil, nil)

var dlpInspectResultsFindingsList* = Call_DlpInspectResultsFindingsList_579077(
    name: "dlpInspectResultsFindingsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}/findings",
    validator: validate_DlpInspectResultsFindingsList_579078, base: "/",
    url: url_DlpInspectResultsFindingsList_579079, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsCancel_579101 = ref object of OpenApiRestCall_578348
proc url_DlpInspectOperationsCancel_579103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpInspectOperationsCancel_579102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels an operation. Use the `inspect.operations.get` to check whether the cancellation succeeded or the operation completed despite cancellation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579104 = path.getOrDefault("name")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "name", valid_579104
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
  var valid_579105 = query.getOrDefault("key")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "key", valid_579105
  var valid_579106 = query.getOrDefault("pp")
  valid_579106 = validateParameter(valid_579106, JBool, required = false,
                                 default = newJBool(true))
  if valid_579106 != nil:
    section.add "pp", valid_579106
  var valid_579107 = query.getOrDefault("prettyPrint")
  valid_579107 = validateParameter(valid_579107, JBool, required = false,
                                 default = newJBool(true))
  if valid_579107 != nil:
    section.add "prettyPrint", valid_579107
  var valid_579108 = query.getOrDefault("oauth_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "oauth_token", valid_579108
  var valid_579109 = query.getOrDefault("$.xgafv")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("1"))
  if valid_579109 != nil:
    section.add "$.xgafv", valid_579109
  var valid_579110 = query.getOrDefault("bearer_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "bearer_token", valid_579110
  var valid_579111 = query.getOrDefault("alt")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("json"))
  if valid_579111 != nil:
    section.add "alt", valid_579111
  var valid_579112 = query.getOrDefault("uploadType")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "uploadType", valid_579112
  var valid_579113 = query.getOrDefault("quotaUser")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "quotaUser", valid_579113
  var valid_579114 = query.getOrDefault("callback")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "callback", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  var valid_579116 = query.getOrDefault("access_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "access_token", valid_579116
  var valid_579117 = query.getOrDefault("upload_protocol")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "upload_protocol", valid_579117
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

proc call*(call_579119: Call_DlpInspectOperationsCancel_579101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels an operation. Use the `inspect.operations.get` to check whether the cancellation succeeded or the operation completed despite cancellation.
  ## 
  let valid = call_579119.validator(path, query, header, formData, body)
  let scheme = call_579119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579119.url(scheme.get, call_579119.host, call_579119.base,
                         call_579119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579119, url, valid)

proc call*(call_579120: Call_DlpInspectOperationsCancel_579101; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpInspectOperationsCancel
  ## Cancels an operation. Use the `inspect.operations.get` to check whether the cancellation succeeded or the operation completed despite cancellation.
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
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579121 = newJObject()
  var query_579122 = newJObject()
  var body_579123 = newJObject()
  add(query_579122, "key", newJString(key))
  add(query_579122, "pp", newJBool(pp))
  add(query_579122, "prettyPrint", newJBool(prettyPrint))
  add(query_579122, "oauth_token", newJString(oauthToken))
  add(query_579122, "$.xgafv", newJString(Xgafv))
  add(query_579122, "bearer_token", newJString(bearerToken))
  add(query_579122, "alt", newJString(alt))
  add(query_579122, "uploadType", newJString(uploadType))
  add(query_579122, "quotaUser", newJString(quotaUser))
  add(path_579121, "name", newJString(name))
  if body != nil:
    body_579123 = body
  add(query_579122, "callback", newJString(callback))
  add(query_579122, "fields", newJString(fields))
  add(query_579122, "access_token", newJString(accessToken))
  add(query_579122, "upload_protocol", newJString(uploadProtocol))
  result = call_579120.call(path_579121, query_579122, nil, nil, body_579123)

var dlpInspectOperationsCancel* = Call_DlpInspectOperationsCancel_579101(
    name: "dlpInspectOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}:cancel",
    validator: validate_DlpInspectOperationsCancel_579102, base: "/",
    url: url_DlpInspectOperationsCancel_579103, schemes: {Scheme.Https})
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
