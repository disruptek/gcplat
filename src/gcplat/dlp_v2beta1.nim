
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_DlpContentDeidentify_579690 = ref object of OpenApiRestCall_579421
proc url_DlpContentDeidentify_579692(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpContentDeidentify_579691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a list of strings.
  ## This method has limits on input size and output size.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579820 = query.getOrDefault("alt")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("json"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("pp")
  valid_579821 = validateParameter(valid_579821, JBool, required = false,
                                 default = newJBool(true))
  if valid_579821 != nil:
    section.add "pp", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("callback")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "callback", valid_579823
  var valid_579824 = query.getOrDefault("access_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "access_token", valid_579824
  var valid_579825 = query.getOrDefault("uploadType")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "uploadType", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("$.xgafv")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = newJString("1"))
  if valid_579827 != nil:
    section.add "$.xgafv", valid_579827
  var valid_579828 = query.getOrDefault("prettyPrint")
  valid_579828 = validateParameter(valid_579828, JBool, required = false,
                                 default = newJBool(true))
  if valid_579828 != nil:
    section.add "prettyPrint", valid_579828
  var valid_579829 = query.getOrDefault("bearer_token")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "bearer_token", valid_579829
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

proc call*(call_579853: Call_DlpContentDeidentify_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a list of strings.
  ## This method has limits on input size and output size.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579924: Call_DlpContentDeidentify_579690;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpContentDeidentify
  ## De-identifies potentially sensitive info from a list of strings.
  ## This method has limits on input size and output size.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_579925 = newJObject()
  var body_579927 = newJObject()
  add(query_579925, "upload_protocol", newJString(uploadProtocol))
  add(query_579925, "fields", newJString(fields))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "pp", newJBool(pp))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "callback", newJString(callback))
  add(query_579925, "access_token", newJString(accessToken))
  add(query_579925, "uploadType", newJString(uploadType))
  add(query_579925, "key", newJString(key))
  add(query_579925, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579927 = body
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  add(query_579925, "bearer_token", newJString(bearerToken))
  result = call_579924.call(nil, query_579925, nil, nil, body_579927)

var dlpContentDeidentify* = Call_DlpContentDeidentify_579690(
    name: "dlpContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/content:deidentify",
    validator: validate_DlpContentDeidentify_579691, base: "/",
    url: url_DlpContentDeidentify_579692, schemes: {Scheme.Https})
type
  Call_DlpContentInspect_579966 = ref object of OpenApiRestCall_579421
proc url_DlpContentInspect_579968(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpContentInspect_579967(path: JsonNode; query: JsonNode;
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("pp")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(true))
  if valid_579973 != nil:
    section.add "pp", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("callback")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "callback", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("uploadType")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "uploadType", valid_579977
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  var valid_579981 = query.getOrDefault("bearer_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "bearer_token", valid_579981
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

proc call*(call_579983: Call_DlpContentInspect_579966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in a list of strings.
  ## This method has limits on input size, processing time, and output size.
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_DlpContentInspect_579966; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpContentInspect
  ## Finds potentially sensitive info in a list of strings.
  ## This method has limits on input size, processing time, and output size.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_579985 = newJObject()
  var body_579986 = newJObject()
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "pp", newJBool(pp))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "key", newJString(key))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579986 = body
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "bearer_token", newJString(bearerToken))
  result = call_579984.call(nil, query_579985, nil, nil, body_579986)

var dlpContentInspect* = Call_DlpContentInspect_579966(name: "dlpContentInspect",
    meth: HttpMethod.HttpPost, host: "dlp.googleapis.com",
    route: "/v2beta1/content:inspect", validator: validate_DlpContentInspect_579967,
    base: "/", url: url_DlpContentInspect_579968, schemes: {Scheme.Https})
type
  Call_DlpContentRedact_579987 = ref object of OpenApiRestCall_579421
proc url_DlpContentRedact_579989(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpContentRedact_579988(path: JsonNode; query: JsonNode;
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
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("pp")
  valid_579994 = validateParameter(valid_579994, JBool, required = false,
                                 default = newJBool(true))
  if valid_579994 != nil:
    section.add "pp", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("callback")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "callback", valid_579996
  var valid_579997 = query.getOrDefault("access_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "access_token", valid_579997
  var valid_579998 = query.getOrDefault("uploadType")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "uploadType", valid_579998
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("$.xgafv")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("1"))
  if valid_580000 != nil:
    section.add "$.xgafv", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
  var valid_580002 = query.getOrDefault("bearer_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "bearer_token", valid_580002
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

proc call*(call_580004: Call_DlpContentRedact_579987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from a list of strings.
  ## This method has limits on input size, processing time, and output size.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_DlpContentRedact_579987; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpContentRedact
  ## Redacts potentially sensitive info from a list of strings.
  ## This method has limits on input size, processing time, and output size.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580006 = newJObject()
  var body_580007 = newJObject()
  add(query_580006, "upload_protocol", newJString(uploadProtocol))
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "pp", newJBool(pp))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "callback", newJString(callback))
  add(query_580006, "access_token", newJString(accessToken))
  add(query_580006, "uploadType", newJString(uploadType))
  add(query_580006, "key", newJString(key))
  add(query_580006, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580007 = body
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  add(query_580006, "bearer_token", newJString(bearerToken))
  result = call_580005.call(nil, query_580006, nil, nil, body_580007)

var dlpContentRedact* = Call_DlpContentRedact_579987(name: "dlpContentRedact",
    meth: HttpMethod.HttpPost, host: "dlp.googleapis.com",
    route: "/v2beta1/content:redact", validator: validate_DlpContentRedact_579988,
    base: "/", url: url_DlpContentRedact_579989, schemes: {Scheme.Https})
type
  Call_DlpDataSourceAnalyze_580008 = ref object of OpenApiRestCall_579421
proc url_DlpDataSourceAnalyze_580010(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpDataSourceAnalyze_580009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("pp")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "pp", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  var valid_580023 = query.getOrDefault("bearer_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "bearer_token", valid_580023
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

proc call*(call_580025: Call_DlpDataSourceAnalyze_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository.
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_DlpDataSourceAnalyze_580008;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpDataSourceAnalyze
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580027 = newJObject()
  var body_580028 = newJObject()
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "pp", newJBool(pp))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "key", newJString(key))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580028 = body
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  add(query_580027, "bearer_token", newJString(bearerToken))
  result = call_580026.call(nil, query_580027, nil, nil, body_580028)

var dlpDataSourceAnalyze* = Call_DlpDataSourceAnalyze_580008(
    name: "dlpDataSourceAnalyze", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/dataSource:analyze",
    validator: validate_DlpDataSourceAnalyze_580009, base: "/",
    url: url_DlpDataSourceAnalyze_580010, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsCreate_580029 = ref object of OpenApiRestCall_579421
proc url_DlpInspectOperationsCreate_580031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpInspectOperationsCreate_580030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("pp")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "pp", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("callback")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "callback", valid_580038
  var valid_580039 = query.getOrDefault("access_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "access_token", valid_580039
  var valid_580040 = query.getOrDefault("uploadType")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "uploadType", valid_580040
  var valid_580041 = query.getOrDefault("key")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "key", valid_580041
  var valid_580042 = query.getOrDefault("$.xgafv")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("1"))
  if valid_580042 != nil:
    section.add "$.xgafv", valid_580042
  var valid_580043 = query.getOrDefault("prettyPrint")
  valid_580043 = validateParameter(valid_580043, JBool, required = false,
                                 default = newJBool(true))
  if valid_580043 != nil:
    section.add "prettyPrint", valid_580043
  var valid_580044 = query.getOrDefault("bearer_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "bearer_token", valid_580044
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

proc call*(call_580046: Call_DlpInspectOperationsCreate_580029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_DlpInspectOperationsCreate_580029;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpInspectOperationsCreate
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580048 = newJObject()
  var body_580049 = newJObject()
  add(query_580048, "upload_protocol", newJString(uploadProtocol))
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "pp", newJBool(pp))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "callback", newJString(callback))
  add(query_580048, "access_token", newJString(accessToken))
  add(query_580048, "uploadType", newJString(uploadType))
  add(query_580048, "key", newJString(key))
  add(query_580048, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580049 = body
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  add(query_580048, "bearer_token", newJString(bearerToken))
  result = call_580047.call(nil, query_580048, nil, nil, body_580049)

var dlpInspectOperationsCreate* = Call_DlpInspectOperationsCreate_580029(
    name: "dlpInspectOperationsCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/inspect/operations",
    validator: validate_DlpInspectOperationsCreate_580030, base: "/",
    url: url_DlpInspectOperationsCreate_580031, schemes: {Scheme.Https})
type
  Call_DlpRootCategoriesList_580050 = ref object of OpenApiRestCall_579421
proc url_DlpRootCategoriesList_580052(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpRootCategoriesList_580051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of root categories of sensitive information.
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
  ##               : Optional language code for localized friendly category names.
  ## If omitted or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("pp")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "pp", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("callback")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "callback", valid_580059
  var valid_580060 = query.getOrDefault("access_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "access_token", valid_580060
  var valid_580061 = query.getOrDefault("uploadType")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "uploadType", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("$.xgafv")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("1"))
  if valid_580063 != nil:
    section.add "$.xgafv", valid_580063
  var valid_580064 = query.getOrDefault("languageCode")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "languageCode", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
  var valid_580066 = query.getOrDefault("bearer_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "bearer_token", valid_580066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580067: Call_DlpRootCategoriesList_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of root categories of sensitive information.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_DlpRootCategoriesList_580050;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpRootCategoriesList
  ## Returns the list of root categories of sensitive information.
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
  ##               : Optional language code for localized friendly category names.
  ## If omitted or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580069 = newJObject()
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "pp", newJBool(pp))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "key", newJString(key))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "languageCode", newJString(languageCode))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "bearer_token", newJString(bearerToken))
  result = call_580068.call(nil, query_580069, nil, nil, nil)

var dlpRootCategoriesList* = Call_DlpRootCategoriesList_580050(
    name: "dlpRootCategoriesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta1/rootCategories",
    validator: validate_DlpRootCategoriesList_580051, base: "/",
    url: url_DlpRootCategoriesList_580052, schemes: {Scheme.Https})
type
  Call_DlpRootCategoriesInfoTypesList_580070 = ref object of OpenApiRestCall_579421
proc url_DlpRootCategoriesInfoTypesList_580072(protocol: Scheme; host: string;
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

proc validate_DlpRootCategoriesInfoTypesList_580071(path: JsonNode;
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
  var valid_580087 = path.getOrDefault("category")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "category", valid_580087
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
  ##               : Optional BCP-47 language code for localized info type friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580088 = query.getOrDefault("upload_protocol")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "upload_protocol", valid_580088
  var valid_580089 = query.getOrDefault("fields")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "fields", valid_580089
  var valid_580090 = query.getOrDefault("quotaUser")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "quotaUser", valid_580090
  var valid_580091 = query.getOrDefault("alt")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("json"))
  if valid_580091 != nil:
    section.add "alt", valid_580091
  var valid_580092 = query.getOrDefault("pp")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "pp", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("callback")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "callback", valid_580094
  var valid_580095 = query.getOrDefault("access_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "access_token", valid_580095
  var valid_580096 = query.getOrDefault("uploadType")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "uploadType", valid_580096
  var valid_580097 = query.getOrDefault("key")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "key", valid_580097
  var valid_580098 = query.getOrDefault("$.xgafv")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("1"))
  if valid_580098 != nil:
    section.add "$.xgafv", valid_580098
  var valid_580099 = query.getOrDefault("languageCode")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "languageCode", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
  var valid_580101 = query.getOrDefault("bearer_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "bearer_token", valid_580101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_DlpRootCategoriesInfoTypesList_580070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns sensitive information types for given category.
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_DlpRootCategoriesInfoTypesList_580070;
          category: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpRootCategoriesInfoTypesList
  ## Returns sensitive information types for given category.
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
  ##   category: string (required)
  ##           : Category name as returned by ListRootCategories.
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
  ##               : Optional BCP-47 language code for localized info type friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580104 = newJObject()
  var query_580105 = newJObject()
  add(query_580105, "upload_protocol", newJString(uploadProtocol))
  add(query_580105, "fields", newJString(fields))
  add(query_580105, "quotaUser", newJString(quotaUser))
  add(query_580105, "alt", newJString(alt))
  add(query_580105, "pp", newJBool(pp))
  add(path_580104, "category", newJString(category))
  add(query_580105, "oauth_token", newJString(oauthToken))
  add(query_580105, "callback", newJString(callback))
  add(query_580105, "access_token", newJString(accessToken))
  add(query_580105, "uploadType", newJString(uploadType))
  add(query_580105, "key", newJString(key))
  add(query_580105, "$.xgafv", newJString(Xgafv))
  add(query_580105, "languageCode", newJString(languageCode))
  add(query_580105, "prettyPrint", newJBool(prettyPrint))
  add(query_580105, "bearer_token", newJString(bearerToken))
  result = call_580103.call(path_580104, query_580105, nil, nil, nil)

var dlpRootCategoriesInfoTypesList* = Call_DlpRootCategoriesInfoTypesList_580070(
    name: "dlpRootCategoriesInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com",
    route: "/v2beta1/rootCategories/{category}/infoTypes",
    validator: validate_DlpRootCategoriesInfoTypesList_580071, base: "/",
    url: url_DlpRootCategoriesInfoTypesList_580072, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsGet_580106 = ref object of OpenApiRestCall_579421
proc url_DlpInspectOperationsGet_580108(protocol: Scheme; host: string; base: string;
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

proc validate_DlpInspectOperationsGet_580107(path: JsonNode; query: JsonNode;
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
  var valid_580109 = path.getOrDefault("name")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "name", valid_580109
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
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("pp")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "pp", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("callback")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "callback", valid_580116
  var valid_580117 = query.getOrDefault("access_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "access_token", valid_580117
  var valid_580118 = query.getOrDefault("uploadType")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "uploadType", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("$.xgafv")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("1"))
  if valid_580120 != nil:
    section.add "$.xgafv", valid_580120
  var valid_580121 = query.getOrDefault("prettyPrint")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "prettyPrint", valid_580121
  var valid_580122 = query.getOrDefault("bearer_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "bearer_token", valid_580122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580123: Call_DlpInspectOperationsGet_580106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_DlpInspectOperationsGet_580106; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpInspectOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_580125 = newJObject()
  var query_580126 = newJObject()
  add(query_580126, "upload_protocol", newJString(uploadProtocol))
  add(query_580126, "fields", newJString(fields))
  add(query_580126, "quotaUser", newJString(quotaUser))
  add(path_580125, "name", newJString(name))
  add(query_580126, "alt", newJString(alt))
  add(query_580126, "pp", newJBool(pp))
  add(query_580126, "oauth_token", newJString(oauthToken))
  add(query_580126, "callback", newJString(callback))
  add(query_580126, "access_token", newJString(accessToken))
  add(query_580126, "uploadType", newJString(uploadType))
  add(query_580126, "key", newJString(key))
  add(query_580126, "$.xgafv", newJString(Xgafv))
  add(query_580126, "prettyPrint", newJBool(prettyPrint))
  add(query_580126, "bearer_token", newJString(bearerToken))
  result = call_580124.call(path_580125, query_580126, nil, nil, nil)

var dlpInspectOperationsGet* = Call_DlpInspectOperationsGet_580106(
    name: "dlpInspectOperationsGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}",
    validator: validate_DlpInspectOperationsGet_580107, base: "/",
    url: url_DlpInspectOperationsGet_580108, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsDelete_580127 = ref object of OpenApiRestCall_579421
proc url_DlpInspectOperationsDelete_580129(protocol: Scheme; host: string;
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

proc validate_DlpInspectOperationsDelete_580128(path: JsonNode; query: JsonNode;
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
  var valid_580130 = path.getOrDefault("name")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "name", valid_580130
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
  var valid_580131 = query.getOrDefault("upload_protocol")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "upload_protocol", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("pp")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "pp", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("callback")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "callback", valid_580137
  var valid_580138 = query.getOrDefault("access_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "access_token", valid_580138
  var valid_580139 = query.getOrDefault("uploadType")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "uploadType", valid_580139
  var valid_580140 = query.getOrDefault("key")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "key", valid_580140
  var valid_580141 = query.getOrDefault("$.xgafv")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("1"))
  if valid_580141 != nil:
    section.add "$.xgafv", valid_580141
  var valid_580142 = query.getOrDefault("prettyPrint")
  valid_580142 = validateParameter(valid_580142, JBool, required = false,
                                 default = newJBool(true))
  if valid_580142 != nil:
    section.add "prettyPrint", valid_580142
  var valid_580143 = query.getOrDefault("bearer_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "bearer_token", valid_580143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580144: Call_DlpInspectOperationsDelete_580127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ## 
  let valid = call_580144.validator(path, query, header, formData, body)
  let scheme = call_580144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580144.url(scheme.get, call_580144.host, call_580144.base,
                         call_580144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580144, url, valid)

proc call*(call_580145: Call_DlpInspectOperationsDelete_580127; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpInspectOperationsDelete
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_580146 = newJObject()
  var query_580147 = newJObject()
  add(query_580147, "upload_protocol", newJString(uploadProtocol))
  add(query_580147, "fields", newJString(fields))
  add(query_580147, "quotaUser", newJString(quotaUser))
  add(path_580146, "name", newJString(name))
  add(query_580147, "alt", newJString(alt))
  add(query_580147, "pp", newJBool(pp))
  add(query_580147, "oauth_token", newJString(oauthToken))
  add(query_580147, "callback", newJString(callback))
  add(query_580147, "access_token", newJString(accessToken))
  add(query_580147, "uploadType", newJString(uploadType))
  add(query_580147, "key", newJString(key))
  add(query_580147, "$.xgafv", newJString(Xgafv))
  add(query_580147, "prettyPrint", newJBool(prettyPrint))
  add(query_580147, "bearer_token", newJString(bearerToken))
  result = call_580145.call(path_580146, query_580147, nil, nil, nil)

var dlpInspectOperationsDelete* = Call_DlpInspectOperationsDelete_580127(
    name: "dlpInspectOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}",
    validator: validate_DlpInspectOperationsDelete_580128, base: "/",
    url: url_DlpInspectOperationsDelete_580129, schemes: {Scheme.Https})
type
  Call_DlpInspectResultsFindingsList_580148 = ref object of OpenApiRestCall_579421
proc url_DlpInspectResultsFindingsList_580150(protocol: Scheme; host: string;
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

proc validate_DlpInspectResultsFindingsList_580149(path: JsonNode; query: JsonNode;
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
  var valid_580151 = path.getOrDefault("name")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "name", valid_580151
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListInspectFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListInspectFindings` call, and that
  ## the system should return the next page of data.
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
  ##           : Maximum number of results to return.
  ## If 0, the implementation selects a reasonable value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580152 = query.getOrDefault("upload_protocol")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "upload_protocol", valid_580152
  var valid_580153 = query.getOrDefault("fields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "fields", valid_580153
  var valid_580154 = query.getOrDefault("pageToken")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "pageToken", valid_580154
  var valid_580155 = query.getOrDefault("quotaUser")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "quotaUser", valid_580155
  var valid_580156 = query.getOrDefault("alt")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("json"))
  if valid_580156 != nil:
    section.add "alt", valid_580156
  var valid_580157 = query.getOrDefault("pp")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "pp", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("callback")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "callback", valid_580159
  var valid_580160 = query.getOrDefault("access_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "access_token", valid_580160
  var valid_580161 = query.getOrDefault("uploadType")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "uploadType", valid_580161
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("$.xgafv")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("1"))
  if valid_580163 != nil:
    section.add "$.xgafv", valid_580163
  var valid_580164 = query.getOrDefault("pageSize")
  valid_580164 = validateParameter(valid_580164, JInt, required = false, default = nil)
  if valid_580164 != nil:
    section.add "pageSize", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
  var valid_580166 = query.getOrDefault("filter")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "filter", valid_580166
  var valid_580167 = query.getOrDefault("bearer_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "bearer_token", valid_580167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580168: Call_DlpInspectResultsFindingsList_580148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of results for given inspect operation result set id.
  ## 
  let valid = call_580168.validator(path, query, header, formData, body)
  let scheme = call_580168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580168.url(scheme.get, call_580168.host, call_580168.base,
                         call_580168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580168, url, valid)

proc call*(call_580169: Call_DlpInspectResultsFindingsList_580148; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
  ## dlpInspectResultsFindingsList
  ## Returns list of results for given inspect operation result set id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListInspectFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListInspectFindings` call, and that
  ## the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Identifier of the results set returned as metadata of
  ## the longrunning operation created by a call to InspectDataSource.
  ## Should be in the format of `inspect/results/{id}`.
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
  ##   pageSize: int
  ##           : Maximum number of results to return.
  ## If 0, the implementation selects a reasonable value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580170 = newJObject()
  var query_580171 = newJObject()
  add(query_580171, "upload_protocol", newJString(uploadProtocol))
  add(query_580171, "fields", newJString(fields))
  add(query_580171, "pageToken", newJString(pageToken))
  add(query_580171, "quotaUser", newJString(quotaUser))
  add(path_580170, "name", newJString(name))
  add(query_580171, "alt", newJString(alt))
  add(query_580171, "pp", newJBool(pp))
  add(query_580171, "oauth_token", newJString(oauthToken))
  add(query_580171, "callback", newJString(callback))
  add(query_580171, "access_token", newJString(accessToken))
  add(query_580171, "uploadType", newJString(uploadType))
  add(query_580171, "key", newJString(key))
  add(query_580171, "$.xgafv", newJString(Xgafv))
  add(query_580171, "pageSize", newJInt(pageSize))
  add(query_580171, "prettyPrint", newJBool(prettyPrint))
  add(query_580171, "filter", newJString(filter))
  add(query_580171, "bearer_token", newJString(bearerToken))
  result = call_580169.call(path_580170, query_580171, nil, nil, nil)

var dlpInspectResultsFindingsList* = Call_DlpInspectResultsFindingsList_580148(
    name: "dlpInspectResultsFindingsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}/findings",
    validator: validate_DlpInspectResultsFindingsList_580149, base: "/",
    url: url_DlpInspectResultsFindingsList_580150, schemes: {Scheme.Https})
type
  Call_DlpInspectOperationsCancel_580172 = ref object of OpenApiRestCall_579421
proc url_DlpInspectOperationsCancel_580174(protocol: Scheme; host: string;
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

proc validate_DlpInspectOperationsCancel_580173(path: JsonNode; query: JsonNode;
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
  var valid_580175 = path.getOrDefault("name")
  valid_580175 = validateParameter(valid_580175, JString, required = true,
                                 default = nil)
  if valid_580175 != nil:
    section.add "name", valid_580175
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
  var valid_580176 = query.getOrDefault("upload_protocol")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "upload_protocol", valid_580176
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
  var valid_580178 = query.getOrDefault("quotaUser")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "quotaUser", valid_580178
  var valid_580179 = query.getOrDefault("alt")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("json"))
  if valid_580179 != nil:
    section.add "alt", valid_580179
  var valid_580180 = query.getOrDefault("pp")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "pp", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("callback")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "callback", valid_580182
  var valid_580183 = query.getOrDefault("access_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "access_token", valid_580183
  var valid_580184 = query.getOrDefault("uploadType")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "uploadType", valid_580184
  var valid_580185 = query.getOrDefault("key")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "key", valid_580185
  var valid_580186 = query.getOrDefault("$.xgafv")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("1"))
  if valid_580186 != nil:
    section.add "$.xgafv", valid_580186
  var valid_580187 = query.getOrDefault("prettyPrint")
  valid_580187 = validateParameter(valid_580187, JBool, required = false,
                                 default = newJBool(true))
  if valid_580187 != nil:
    section.add "prettyPrint", valid_580187
  var valid_580188 = query.getOrDefault("bearer_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "bearer_token", valid_580188
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

proc call*(call_580190: Call_DlpInspectOperationsCancel_580172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels an operation. Use the `inspect.operations.get` to check whether the cancellation succeeded or the operation completed despite cancellation.
  ## 
  let valid = call_580190.validator(path, query, header, formData, body)
  let scheme = call_580190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580190.url(scheme.get, call_580190.host, call_580190.base,
                         call_580190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580190, url, valid)

proc call*(call_580191: Call_DlpInspectOperationsCancel_580172; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpInspectOperationsCancel
  ## Cancels an operation. Use the `inspect.operations.get` to check whether the cancellation succeeded or the operation completed despite cancellation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_580192 = newJObject()
  var query_580193 = newJObject()
  var body_580194 = newJObject()
  add(query_580193, "upload_protocol", newJString(uploadProtocol))
  add(query_580193, "fields", newJString(fields))
  add(query_580193, "quotaUser", newJString(quotaUser))
  add(path_580192, "name", newJString(name))
  add(query_580193, "alt", newJString(alt))
  add(query_580193, "pp", newJBool(pp))
  add(query_580193, "oauth_token", newJString(oauthToken))
  add(query_580193, "callback", newJString(callback))
  add(query_580193, "access_token", newJString(accessToken))
  add(query_580193, "uploadType", newJString(uploadType))
  add(query_580193, "key", newJString(key))
  add(query_580193, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580194 = body
  add(query_580193, "prettyPrint", newJBool(prettyPrint))
  add(query_580193, "bearer_token", newJString(bearerToken))
  result = call_580191.call(path_580192, query_580193, nil, nil, body_580194)

var dlpInspectOperationsCancel* = Call_DlpInspectOperationsCancel_580172(
    name: "dlpInspectOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta1/{name}:cancel",
    validator: validate_DlpInspectOperationsCancel_580173, base: "/",
    url: url_DlpInspectOperationsCancel_580174, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
