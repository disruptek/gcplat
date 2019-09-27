
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Abusive Experience Report
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Views Abusive Experience Report data, and gets a list of sites that have a significant number of abusive experiences.
## 
## https://developers.google.com/abusive-experience-report/
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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "abusiveexperiencereport"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AbusiveexperiencereportViolatingSitesList_597677 = ref object of OpenApiRestCall_597408
proc url_AbusiveexperiencereportViolatingSitesList_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AbusiveexperiencereportViolatingSitesList_597678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists sites that are failing in the Abusive Experience Report.
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
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("quotaUser")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "quotaUser", valid_597793
  var valid_597807 = query.getOrDefault("alt")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = newJString("json"))
  if valid_597807 != nil:
    section.add "alt", valid_597807
  var valid_597808 = query.getOrDefault("oauth_token")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "oauth_token", valid_597808
  var valid_597809 = query.getOrDefault("callback")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "callback", valid_597809
  var valid_597810 = query.getOrDefault("access_token")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "access_token", valid_597810
  var valid_597811 = query.getOrDefault("uploadType")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "uploadType", valid_597811
  var valid_597812 = query.getOrDefault("key")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "key", valid_597812
  var valid_597813 = query.getOrDefault("$.xgafv")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = newJString("1"))
  if valid_597813 != nil:
    section.add "$.xgafv", valid_597813
  var valid_597814 = query.getOrDefault("prettyPrint")
  valid_597814 = validateParameter(valid_597814, JBool, required = false,
                                 default = newJBool(true))
  if valid_597814 != nil:
    section.add "prettyPrint", valid_597814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597837: Call_AbusiveexperiencereportViolatingSitesList_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists sites that are failing in the Abusive Experience Report.
  ## 
  let valid = call_597837.validator(path, query, header, formData, body)
  let scheme = call_597837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597837.url(scheme.get, call_597837.host, call_597837.base,
                         call_597837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597837, url, valid)

proc call*(call_597908: Call_AbusiveexperiencereportViolatingSitesList_597677;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## abusiveexperiencereportViolatingSitesList
  ## Lists sites that are failing in the Abusive Experience Report.
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
  var query_597909 = newJObject()
  add(query_597909, "upload_protocol", newJString(uploadProtocol))
  add(query_597909, "fields", newJString(fields))
  add(query_597909, "quotaUser", newJString(quotaUser))
  add(query_597909, "alt", newJString(alt))
  add(query_597909, "oauth_token", newJString(oauthToken))
  add(query_597909, "callback", newJString(callback))
  add(query_597909, "access_token", newJString(accessToken))
  add(query_597909, "uploadType", newJString(uploadType))
  add(query_597909, "key", newJString(key))
  add(query_597909, "$.xgafv", newJString(Xgafv))
  add(query_597909, "prettyPrint", newJBool(prettyPrint))
  result = call_597908.call(nil, query_597909, nil, nil, nil)

var abusiveexperiencereportViolatingSitesList* = Call_AbusiveexperiencereportViolatingSitesList_597677(
    name: "abusiveexperiencereportViolatingSitesList", meth: HttpMethod.HttpGet,
    host: "abusiveexperiencereport.googleapis.com", route: "/v1/violatingSites",
    validator: validate_AbusiveexperiencereportViolatingSitesList_597678,
    base: "/", url: url_AbusiveexperiencereportViolatingSitesList_597679,
    schemes: {Scheme.Https})
type
  Call_AbusiveexperiencereportSitesGet_597949 = ref object of OpenApiRestCall_597408
proc url_AbusiveexperiencereportSitesGet_597951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AbusiveexperiencereportSitesGet_597950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a site's Abusive Experience Report summary.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the site whose summary to get, e.g.
  ## `sites/http%3A%2F%2Fwww.google.com%2F`.
  ## 
  ## Format: `sites/{site}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597966 = path.getOrDefault("name")
  valid_597966 = validateParameter(valid_597966, JString, required = true,
                                 default = nil)
  if valid_597966 != nil:
    section.add "name", valid_597966
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
  var valid_597967 = query.getOrDefault("upload_protocol")
  valid_597967 = validateParameter(valid_597967, JString, required = false,
                                 default = nil)
  if valid_597967 != nil:
    section.add "upload_protocol", valid_597967
  var valid_597968 = query.getOrDefault("fields")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = nil)
  if valid_597968 != nil:
    section.add "fields", valid_597968
  var valid_597969 = query.getOrDefault("quotaUser")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "quotaUser", valid_597969
  var valid_597970 = query.getOrDefault("alt")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = newJString("json"))
  if valid_597970 != nil:
    section.add "alt", valid_597970
  var valid_597971 = query.getOrDefault("oauth_token")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "oauth_token", valid_597971
  var valid_597972 = query.getOrDefault("callback")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "callback", valid_597972
  var valid_597973 = query.getOrDefault("access_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "access_token", valid_597973
  var valid_597974 = query.getOrDefault("uploadType")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "uploadType", valid_597974
  var valid_597975 = query.getOrDefault("key")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "key", valid_597975
  var valid_597976 = query.getOrDefault("$.xgafv")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = newJString("1"))
  if valid_597976 != nil:
    section.add "$.xgafv", valid_597976
  var valid_597977 = query.getOrDefault("prettyPrint")
  valid_597977 = validateParameter(valid_597977, JBool, required = false,
                                 default = newJBool(true))
  if valid_597977 != nil:
    section.add "prettyPrint", valid_597977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597978: Call_AbusiveexperiencereportSitesGet_597949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a site's Abusive Experience Report summary.
  ## 
  let valid = call_597978.validator(path, query, header, formData, body)
  let scheme = call_597978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597978.url(scheme.get, call_597978.host, call_597978.base,
                         call_597978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597978, url, valid)

proc call*(call_597979: Call_AbusiveexperiencereportSitesGet_597949; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## abusiveexperiencereportSitesGet
  ## Gets a site's Abusive Experience Report summary.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the site whose summary to get, e.g.
  ## `sites/http%3A%2F%2Fwww.google.com%2F`.
  ## 
  ## Format: `sites/{site}`
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
  var path_597980 = newJObject()
  var query_597981 = newJObject()
  add(query_597981, "upload_protocol", newJString(uploadProtocol))
  add(query_597981, "fields", newJString(fields))
  add(query_597981, "quotaUser", newJString(quotaUser))
  add(path_597980, "name", newJString(name))
  add(query_597981, "alt", newJString(alt))
  add(query_597981, "oauth_token", newJString(oauthToken))
  add(query_597981, "callback", newJString(callback))
  add(query_597981, "access_token", newJString(accessToken))
  add(query_597981, "uploadType", newJString(uploadType))
  add(query_597981, "key", newJString(key))
  add(query_597981, "$.xgafv", newJString(Xgafv))
  add(query_597981, "prettyPrint", newJBool(prettyPrint))
  result = call_597979.call(path_597980, query_597981, nil, nil, nil)

var abusiveexperiencereportSitesGet* = Call_AbusiveexperiencereportSitesGet_597949(
    name: "abusiveexperiencereportSitesGet", meth: HttpMethod.HttpGet,
    host: "abusiveexperiencereport.googleapis.com", route: "/v1/{name}",
    validator: validate_AbusiveexperiencereportSitesGet_597950, base: "/",
    url: url_AbusiveexperiencereportSitesGet_597951, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
