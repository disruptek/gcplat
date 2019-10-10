
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Domains RDAP
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Read-only public API that lets users search for information about domain names.
## 
## https://developers.google.com/domains/rdap/
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "domainsrdap"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DomainsrdapAutnumGet_588710 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapAutnumGet_588712(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "autnumId" in path, "`autnumId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/autnum/"),
               (kind: VariableSegment, value: "autnumId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsrdapAutnumGet_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   autnumId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `autnumId` field"
  var valid_588838 = path.getOrDefault("autnumId")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "autnumId", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_DomainsrdapAutnumGet_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_DomainsrdapAutnumGet_588710; autnumId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapAutnumGet
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   autnumId: string (required)
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
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(query_588959, "alt", newJString(alt))
  add(path_588957, "autnumId", newJString(autnumId))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var domainsrdapAutnumGet* = Call_DomainsrdapAutnumGet_588710(
    name: "domainsrdapAutnumGet", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/autnum/{autnumId}",
    validator: validate_DomainsrdapAutnumGet_588711, base: "/",
    url: url_DomainsrdapAutnumGet_588712, schemes: {Scheme.Https})
type
  Call_DomainsrdapDomainGet_588998 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapDomainGet_589000(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/domain/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsrdapDomainGet_588999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Look up RDAP information for a domain by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainName: JString (required)
  ##             : Full domain name to look up. Example: "example.com"
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainName` field"
  var valid_589001 = path.getOrDefault("domainName")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "domainName", valid_589001
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_DomainsrdapDomainGet_588998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Look up RDAP information for a domain by name.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_DomainsrdapDomainGet_588998; domainName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapDomainGet
  ## Look up RDAP information for a domain by name.
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
  ##   domainName: string (required)
  ##             : Full domain name to look up. Example: "example.com"
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589015 = newJObject()
  var query_589016 = newJObject()
  add(query_589016, "upload_protocol", newJString(uploadProtocol))
  add(query_589016, "fields", newJString(fields))
  add(query_589016, "quotaUser", newJString(quotaUser))
  add(query_589016, "alt", newJString(alt))
  add(query_589016, "oauth_token", newJString(oauthToken))
  add(query_589016, "callback", newJString(callback))
  add(query_589016, "access_token", newJString(accessToken))
  add(query_589016, "uploadType", newJString(uploadType))
  add(query_589016, "key", newJString(key))
  add(query_589016, "$.xgafv", newJString(Xgafv))
  add(path_589015, "domainName", newJString(domainName))
  add(query_589016, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(path_589015, query_589016, nil, nil, nil)

var domainsrdapDomainGet* = Call_DomainsrdapDomainGet_588998(
    name: "domainsrdapDomainGet", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/domain/{domainName}",
    validator: validate_DomainsrdapDomainGet_588999, base: "/",
    url: url_DomainsrdapDomainGet_589000, schemes: {Scheme.Https})
type
  Call_DomainsrdapGetDomains_589017 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapGetDomains_589019(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DomainsrdapGetDomains_589018(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589020 = query.getOrDefault("upload_protocol")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "upload_protocol", valid_589020
  var valid_589021 = query.getOrDefault("fields")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "fields", valid_589021
  var valid_589022 = query.getOrDefault("quotaUser")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "quotaUser", valid_589022
  var valid_589023 = query.getOrDefault("alt")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("json"))
  if valid_589023 != nil:
    section.add "alt", valid_589023
  var valid_589024 = query.getOrDefault("oauth_token")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "oauth_token", valid_589024
  var valid_589025 = query.getOrDefault("callback")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "callback", valid_589025
  var valid_589026 = query.getOrDefault("access_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "access_token", valid_589026
  var valid_589027 = query.getOrDefault("uploadType")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "uploadType", valid_589027
  var valid_589028 = query.getOrDefault("key")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "key", valid_589028
  var valid_589029 = query.getOrDefault("$.xgafv")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("1"))
  if valid_589029 != nil:
    section.add "$.xgafv", valid_589029
  var valid_589030 = query.getOrDefault("prettyPrint")
  valid_589030 = validateParameter(valid_589030, JBool, required = false,
                                 default = newJBool(true))
  if valid_589030 != nil:
    section.add "prettyPrint", valid_589030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589031: Call_DomainsrdapGetDomains_589017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_589031.validator(path, query, header, formData, body)
  let scheme = call_589031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589031.url(scheme.get, call_589031.host, call_589031.base,
                         call_589031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589031, url, valid)

proc call*(call_589032: Call_DomainsrdapGetDomains_589017;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapGetDomains
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589033 = newJObject()
  add(query_589033, "upload_protocol", newJString(uploadProtocol))
  add(query_589033, "fields", newJString(fields))
  add(query_589033, "quotaUser", newJString(quotaUser))
  add(query_589033, "alt", newJString(alt))
  add(query_589033, "oauth_token", newJString(oauthToken))
  add(query_589033, "callback", newJString(callback))
  add(query_589033, "access_token", newJString(accessToken))
  add(query_589033, "uploadType", newJString(uploadType))
  add(query_589033, "key", newJString(key))
  add(query_589033, "$.xgafv", newJString(Xgafv))
  add(query_589033, "prettyPrint", newJBool(prettyPrint))
  result = call_589032.call(nil, query_589033, nil, nil, nil)

var domainsrdapGetDomains* = Call_DomainsrdapGetDomains_589017(
    name: "domainsrdapGetDomains", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/domains",
    validator: validate_DomainsrdapGetDomains_589018, base: "/",
    url: url_DomainsrdapGetDomains_589019, schemes: {Scheme.Https})
type
  Call_DomainsrdapGetEntities_589034 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapGetEntities_589036(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DomainsrdapGetEntities_589035(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589037 = query.getOrDefault("upload_protocol")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "upload_protocol", valid_589037
  var valid_589038 = query.getOrDefault("fields")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "fields", valid_589038
  var valid_589039 = query.getOrDefault("quotaUser")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "quotaUser", valid_589039
  var valid_589040 = query.getOrDefault("alt")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("json"))
  if valid_589040 != nil:
    section.add "alt", valid_589040
  var valid_589041 = query.getOrDefault("oauth_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "oauth_token", valid_589041
  var valid_589042 = query.getOrDefault("callback")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "callback", valid_589042
  var valid_589043 = query.getOrDefault("access_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "access_token", valid_589043
  var valid_589044 = query.getOrDefault("uploadType")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "uploadType", valid_589044
  var valid_589045 = query.getOrDefault("key")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "key", valid_589045
  var valid_589046 = query.getOrDefault("$.xgafv")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("1"))
  if valid_589046 != nil:
    section.add "$.xgafv", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589048: Call_DomainsrdapGetEntities_589034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_589048.validator(path, query, header, formData, body)
  let scheme = call_589048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589048.url(scheme.get, call_589048.host, call_589048.base,
                         call_589048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589048, url, valid)

proc call*(call_589049: Call_DomainsrdapGetEntities_589034;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapGetEntities
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589050 = newJObject()
  add(query_589050, "upload_protocol", newJString(uploadProtocol))
  add(query_589050, "fields", newJString(fields))
  add(query_589050, "quotaUser", newJString(quotaUser))
  add(query_589050, "alt", newJString(alt))
  add(query_589050, "oauth_token", newJString(oauthToken))
  add(query_589050, "callback", newJString(callback))
  add(query_589050, "access_token", newJString(accessToken))
  add(query_589050, "uploadType", newJString(uploadType))
  add(query_589050, "key", newJString(key))
  add(query_589050, "$.xgafv", newJString(Xgafv))
  add(query_589050, "prettyPrint", newJBool(prettyPrint))
  result = call_589049.call(nil, query_589050, nil, nil, nil)

var domainsrdapGetEntities* = Call_DomainsrdapGetEntities_589034(
    name: "domainsrdapGetEntities", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/entities",
    validator: validate_DomainsrdapGetEntities_589035, base: "/",
    url: url_DomainsrdapGetEntities_589036, schemes: {Scheme.Https})
type
  Call_DomainsrdapEntityGet_589051 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapEntityGet_589053(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/entity/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsrdapEntityGet_589052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_589054 = path.getOrDefault("entityId")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "entityId", valid_589054
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
  var valid_589059 = query.getOrDefault("oauth_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "oauth_token", valid_589059
  var valid_589060 = query.getOrDefault("callback")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "callback", valid_589060
  var valid_589061 = query.getOrDefault("access_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "access_token", valid_589061
  var valid_589062 = query.getOrDefault("uploadType")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "uploadType", valid_589062
  var valid_589063 = query.getOrDefault("key")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "key", valid_589063
  var valid_589064 = query.getOrDefault("$.xgafv")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("1"))
  if valid_589064 != nil:
    section.add "$.xgafv", valid_589064
  var valid_589065 = query.getOrDefault("prettyPrint")
  valid_589065 = validateParameter(valid_589065, JBool, required = false,
                                 default = newJBool(true))
  if valid_589065 != nil:
    section.add "prettyPrint", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589066: Call_DomainsrdapEntityGet_589051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_DomainsrdapEntityGet_589051; entityId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapEntityGet
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   entityId: string (required)
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
  var path_589068 = newJObject()
  var query_589069 = newJObject()
  add(query_589069, "upload_protocol", newJString(uploadProtocol))
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(query_589069, "alt", newJString(alt))
  add(path_589068, "entityId", newJString(entityId))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "callback", newJString(callback))
  add(query_589069, "access_token", newJString(accessToken))
  add(query_589069, "uploadType", newJString(uploadType))
  add(query_589069, "key", newJString(key))
  add(query_589069, "$.xgafv", newJString(Xgafv))
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  result = call_589067.call(path_589068, query_589069, nil, nil, nil)

var domainsrdapEntityGet* = Call_DomainsrdapEntityGet_589051(
    name: "domainsrdapEntityGet", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/entity/{entityId}",
    validator: validate_DomainsrdapEntityGet_589052, base: "/",
    url: url_DomainsrdapEntityGet_589053, schemes: {Scheme.Https})
type
  Call_DomainsrdapGetHelp_589070 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapGetHelp_589072(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DomainsrdapGetHelp_589071(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get help information for the RDAP API, including links to documentation.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589073 = query.getOrDefault("upload_protocol")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "upload_protocol", valid_589073
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("callback")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "callback", valid_589078
  var valid_589079 = query.getOrDefault("access_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "access_token", valid_589079
  var valid_589080 = query.getOrDefault("uploadType")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "uploadType", valid_589080
  var valid_589081 = query.getOrDefault("key")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "key", valid_589081
  var valid_589082 = query.getOrDefault("$.xgafv")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("1"))
  if valid_589082 != nil:
    section.add "$.xgafv", valid_589082
  var valid_589083 = query.getOrDefault("prettyPrint")
  valid_589083 = validateParameter(valid_589083, JBool, required = false,
                                 default = newJBool(true))
  if valid_589083 != nil:
    section.add "prettyPrint", valid_589083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589084: Call_DomainsrdapGetHelp_589070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get help information for the RDAP API, including links to documentation.
  ## 
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_DomainsrdapGetHelp_589070;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapGetHelp
  ## Get help information for the RDAP API, including links to documentation.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589086 = newJObject()
  add(query_589086, "upload_protocol", newJString(uploadProtocol))
  add(query_589086, "fields", newJString(fields))
  add(query_589086, "quotaUser", newJString(quotaUser))
  add(query_589086, "alt", newJString(alt))
  add(query_589086, "oauth_token", newJString(oauthToken))
  add(query_589086, "callback", newJString(callback))
  add(query_589086, "access_token", newJString(accessToken))
  add(query_589086, "uploadType", newJString(uploadType))
  add(query_589086, "key", newJString(key))
  add(query_589086, "$.xgafv", newJString(Xgafv))
  add(query_589086, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(nil, query_589086, nil, nil, nil)

var domainsrdapGetHelp* = Call_DomainsrdapGetHelp_589070(
    name: "domainsrdapGetHelp", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/help",
    validator: validate_DomainsrdapGetHelp_589071, base: "/",
    url: url_DomainsrdapGetHelp_589072, schemes: {Scheme.Https})
type
  Call_DomainsrdapGetIp_589087 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapGetIp_589089(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DomainsrdapGetIp_589088(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589090 = query.getOrDefault("upload_protocol")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "upload_protocol", valid_589090
  var valid_589091 = query.getOrDefault("fields")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fields", valid_589091
  var valid_589092 = query.getOrDefault("quotaUser")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "quotaUser", valid_589092
  var valid_589093 = query.getOrDefault("alt")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("json"))
  if valid_589093 != nil:
    section.add "alt", valid_589093
  var valid_589094 = query.getOrDefault("oauth_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "oauth_token", valid_589094
  var valid_589095 = query.getOrDefault("callback")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "callback", valid_589095
  var valid_589096 = query.getOrDefault("access_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "access_token", valid_589096
  var valid_589097 = query.getOrDefault("uploadType")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "uploadType", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
  var valid_589099 = query.getOrDefault("$.xgafv")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = newJString("1"))
  if valid_589099 != nil:
    section.add "$.xgafv", valid_589099
  var valid_589100 = query.getOrDefault("prettyPrint")
  valid_589100 = validateParameter(valid_589100, JBool, required = false,
                                 default = newJBool(true))
  if valid_589100 != nil:
    section.add "prettyPrint", valid_589100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589101: Call_DomainsrdapGetIp_589087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_589101.validator(path, query, header, formData, body)
  let scheme = call_589101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589101.url(scheme.get, call_589101.host, call_589101.base,
                         call_589101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589101, url, valid)

proc call*(call_589102: Call_DomainsrdapGetIp_589087; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## domainsrdapGetIp
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589103 = newJObject()
  add(query_589103, "upload_protocol", newJString(uploadProtocol))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "callback", newJString(callback))
  add(query_589103, "access_token", newJString(accessToken))
  add(query_589103, "uploadType", newJString(uploadType))
  add(query_589103, "key", newJString(key))
  add(query_589103, "$.xgafv", newJString(Xgafv))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589102.call(nil, query_589103, nil, nil, nil)

var domainsrdapGetIp* = Call_DomainsrdapGetIp_589087(name: "domainsrdapGetIp",
    meth: HttpMethod.HttpGet, host: "domainsrdap.googleapis.com", route: "/v1/ip",
    validator: validate_DomainsrdapGetIp_589088, base: "/",
    url: url_DomainsrdapGetIp_589089, schemes: {Scheme.Https})
type
  Call_DomainsrdapIpGet_589104 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapIpGet_589106(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "ipId" in path, "`ipId` is a required path parameter"
  assert "ipId1" in path, "`ipId1` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/ip/"),
               (kind: VariableSegment, value: "ipId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "ipId1")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsrdapIpGet_589105(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ipId1: JString (required)
  ##   ipId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ipId1` field"
  var valid_589107 = path.getOrDefault("ipId1")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "ipId1", valid_589107
  var valid_589108 = path.getOrDefault("ipId")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "ipId", valid_589108
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
  var valid_589109 = query.getOrDefault("upload_protocol")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "upload_protocol", valid_589109
  var valid_589110 = query.getOrDefault("fields")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "fields", valid_589110
  var valid_589111 = query.getOrDefault("quotaUser")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "quotaUser", valid_589111
  var valid_589112 = query.getOrDefault("alt")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = newJString("json"))
  if valid_589112 != nil:
    section.add "alt", valid_589112
  var valid_589113 = query.getOrDefault("oauth_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "oauth_token", valid_589113
  var valid_589114 = query.getOrDefault("callback")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "callback", valid_589114
  var valid_589115 = query.getOrDefault("access_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "access_token", valid_589115
  var valid_589116 = query.getOrDefault("uploadType")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "uploadType", valid_589116
  var valid_589117 = query.getOrDefault("key")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "key", valid_589117
  var valid_589118 = query.getOrDefault("$.xgafv")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = newJString("1"))
  if valid_589118 != nil:
    section.add "$.xgafv", valid_589118
  var valid_589119 = query.getOrDefault("prettyPrint")
  valid_589119 = validateParameter(valid_589119, JBool, required = false,
                                 default = newJBool(true))
  if valid_589119 != nil:
    section.add "prettyPrint", valid_589119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589120: Call_DomainsrdapIpGet_589104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_DomainsrdapIpGet_589104; ipId1: string; ipId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapIpGet
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   ipId1: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ipId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589122 = newJObject()
  var query_589123 = newJObject()
  add(query_589123, "upload_protocol", newJString(uploadProtocol))
  add(query_589123, "fields", newJString(fields))
  add(query_589123, "quotaUser", newJString(quotaUser))
  add(query_589123, "alt", newJString(alt))
  add(path_589122, "ipId1", newJString(ipId1))
  add(query_589123, "oauth_token", newJString(oauthToken))
  add(query_589123, "callback", newJString(callback))
  add(query_589123, "access_token", newJString(accessToken))
  add(query_589123, "uploadType", newJString(uploadType))
  add(path_589122, "ipId", newJString(ipId))
  add(query_589123, "key", newJString(key))
  add(query_589123, "$.xgafv", newJString(Xgafv))
  add(query_589123, "prettyPrint", newJBool(prettyPrint))
  result = call_589121.call(path_589122, query_589123, nil, nil, nil)

var domainsrdapIpGet* = Call_DomainsrdapIpGet_589104(name: "domainsrdapIpGet",
    meth: HttpMethod.HttpGet, host: "domainsrdap.googleapis.com",
    route: "/v1/ip/{ipId}/{ipId1}", validator: validate_DomainsrdapIpGet_589105,
    base: "/", url: url_DomainsrdapIpGet_589106, schemes: {Scheme.Https})
type
  Call_DomainsrdapNameserverGet_589124 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapNameserverGet_589126(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "nameserverId" in path, "`nameserverId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/nameserver/"),
               (kind: VariableSegment, value: "nameserverId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsrdapNameserverGet_589125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nameserverId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `nameserverId` field"
  var valid_589127 = path.getOrDefault("nameserverId")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "nameserverId", valid_589127
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
  var valid_589128 = query.getOrDefault("upload_protocol")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "upload_protocol", valid_589128
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  var valid_589133 = query.getOrDefault("callback")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "callback", valid_589133
  var valid_589134 = query.getOrDefault("access_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "access_token", valid_589134
  var valid_589135 = query.getOrDefault("uploadType")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "uploadType", valid_589135
  var valid_589136 = query.getOrDefault("key")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "key", valid_589136
  var valid_589137 = query.getOrDefault("$.xgafv")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("1"))
  if valid_589137 != nil:
    section.add "$.xgafv", valid_589137
  var valid_589138 = query.getOrDefault("prettyPrint")
  valid_589138 = validateParameter(valid_589138, JBool, required = false,
                                 default = newJBool(true))
  if valid_589138 != nil:
    section.add "prettyPrint", valid_589138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589139: Call_DomainsrdapNameserverGet_589124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_589139.validator(path, query, header, formData, body)
  let scheme = call_589139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589139.url(scheme.get, call_589139.host, call_589139.base,
                         call_589139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589139, url, valid)

proc call*(call_589140: Call_DomainsrdapNameserverGet_589124; nameserverId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapNameserverGet
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   nameserverId: string (required)
  var path_589141 = newJObject()
  var query_589142 = newJObject()
  add(query_589142, "upload_protocol", newJString(uploadProtocol))
  add(query_589142, "fields", newJString(fields))
  add(query_589142, "quotaUser", newJString(quotaUser))
  add(query_589142, "alt", newJString(alt))
  add(query_589142, "oauth_token", newJString(oauthToken))
  add(query_589142, "callback", newJString(callback))
  add(query_589142, "access_token", newJString(accessToken))
  add(query_589142, "uploadType", newJString(uploadType))
  add(query_589142, "key", newJString(key))
  add(query_589142, "$.xgafv", newJString(Xgafv))
  add(query_589142, "prettyPrint", newJBool(prettyPrint))
  add(path_589141, "nameserverId", newJString(nameserverId))
  result = call_589140.call(path_589141, query_589142, nil, nil, nil)

var domainsrdapNameserverGet* = Call_DomainsrdapNameserverGet_589124(
    name: "domainsrdapNameserverGet", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/nameserver/{nameserverId}",
    validator: validate_DomainsrdapNameserverGet_589125, base: "/",
    url: url_DomainsrdapNameserverGet_589126, schemes: {Scheme.Https})
type
  Call_DomainsrdapGetNameservers_589143 = ref object of OpenApiRestCall_588441
proc url_DomainsrdapGetNameservers_589145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DomainsrdapGetNameservers_589144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589146 = query.getOrDefault("upload_protocol")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "upload_protocol", valid_589146
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("callback")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "callback", valid_589151
  var valid_589152 = query.getOrDefault("access_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "access_token", valid_589152
  var valid_589153 = query.getOrDefault("uploadType")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "uploadType", valid_589153
  var valid_589154 = query.getOrDefault("key")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "key", valid_589154
  var valid_589155 = query.getOrDefault("$.xgafv")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("1"))
  if valid_589155 != nil:
    section.add "$.xgafv", valid_589155
  var valid_589156 = query.getOrDefault("prettyPrint")
  valid_589156 = validateParameter(valid_589156, JBool, required = false,
                                 default = newJBool(true))
  if valid_589156 != nil:
    section.add "prettyPrint", valid_589156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589157: Call_DomainsrdapGetNameservers_589143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
  ## 
  let valid = call_589157.validator(path, query, header, formData, body)
  let scheme = call_589157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589157.url(scheme.get, call_589157.host, call_589157.base,
                         call_589157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589157, url, valid)

proc call*(call_589158: Call_DomainsrdapGetNameservers_589143;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## domainsrdapGetNameservers
  ## The RDAP API recognizes this command from the RDAP specification but
  ## does not support it. The response is a formatted 501 error.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589159 = newJObject()
  add(query_589159, "upload_protocol", newJString(uploadProtocol))
  add(query_589159, "fields", newJString(fields))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(query_589159, "alt", newJString(alt))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "callback", newJString(callback))
  add(query_589159, "access_token", newJString(accessToken))
  add(query_589159, "uploadType", newJString(uploadType))
  add(query_589159, "key", newJString(key))
  add(query_589159, "$.xgafv", newJString(Xgafv))
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  result = call_589158.call(nil, query_589159, nil, nil, nil)

var domainsrdapGetNameservers* = Call_DomainsrdapGetNameservers_589143(
    name: "domainsrdapGetNameservers", meth: HttpMethod.HttpGet,
    host: "domainsrdap.googleapis.com", route: "/v1/nameservers",
    validator: validate_DomainsrdapGetNameservers_589144, base: "/",
    url: url_DomainsrdapGetNameservers_589145, schemes: {Scheme.Https})
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
