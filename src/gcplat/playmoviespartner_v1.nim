
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Movies Partner
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Gets the delivery status of titles for Google Play Movies Partners.
## 
## https://developers.google.com/playmoviespartner/
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "playmoviespartner"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlaymoviespartnerAccountsAvailsList_579677 = ref object of OpenApiRestCall_579408
proc url_PlaymoviespartnerAccountsAvailsList_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/avails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsAvailsList_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579805 = path.getOrDefault("accountId")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "accountId", valid_579805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Avails that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   altIds: JArray
  ##         : Filter Avails that match (case-insensitive) any of the given partner-specific custom ids.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   altId: JString
  ##        : Filter Avails that match a case-insensitive, partner-specific custom id.
  ## NOTE: this field is deprecated and will be removed on V2; `alt_ids`
  ## should be used instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   title: JString
  ##        : Filter that matches Avails with a `title_internal_alias`,
  ## `series_title_internal_alias`, `season_title_internal_alias`,
  ## or `episode_title_internal_alias` that contains the given
  ## case-insensitive title.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   territories: JArray
  ##              : Filter Avails that match (case-insensitive) any of the given country codes,
  ## using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("pageToken")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "pageToken", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579810 = query.getOrDefault("studioNames")
  valid_579810 = validateParameter(valid_579810, JArray, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "studioNames", valid_579810
  var valid_579824 = query.getOrDefault("alt")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = newJString("json"))
  if valid_579824 != nil:
    section.add "alt", valid_579824
  var valid_579825 = query.getOrDefault("pp")
  valid_579825 = validateParameter(valid_579825, JBool, required = false,
                                 default = newJBool(true))
  if valid_579825 != nil:
    section.add "pp", valid_579825
  var valid_579826 = query.getOrDefault("videoIds")
  valid_579826 = validateParameter(valid_579826, JArray, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "videoIds", valid_579826
  var valid_579827 = query.getOrDefault("pphNames")
  valid_579827 = validateParameter(valid_579827, JArray, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "pphNames", valid_579827
  var valid_579828 = query.getOrDefault("altIds")
  valid_579828 = validateParameter(valid_579828, JArray, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "altIds", valid_579828
  var valid_579829 = query.getOrDefault("oauth_token")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "oauth_token", valid_579829
  var valid_579830 = query.getOrDefault("uploadType")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "uploadType", valid_579830
  var valid_579831 = query.getOrDefault("access_token")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "access_token", valid_579831
  var valid_579832 = query.getOrDefault("callback")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "callback", valid_579832
  var valid_579833 = query.getOrDefault("altId")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "altId", valid_579833
  var valid_579834 = query.getOrDefault("key")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "key", valid_579834
  var valid_579835 = query.getOrDefault("title")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "title", valid_579835
  var valid_579836 = query.getOrDefault("$.xgafv")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = newJString("1"))
  if valid_579836 != nil:
    section.add "$.xgafv", valid_579836
  var valid_579837 = query.getOrDefault("pageSize")
  valid_579837 = validateParameter(valid_579837, JInt, required = false, default = nil)
  if valid_579837 != nil:
    section.add "pageSize", valid_579837
  var valid_579838 = query.getOrDefault("prettyPrint")
  valid_579838 = validateParameter(valid_579838, JBool, required = false,
                                 default = newJBool(true))
  if valid_579838 != nil:
    section.add "prettyPrint", valid_579838
  var valid_579839 = query.getOrDefault("territories")
  valid_579839 = validateParameter(valid_579839, JArray, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "territories", valid_579839
  var valid_579840 = query.getOrDefault("bearer_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "bearer_token", valid_579840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579863: Call_PlaymoviespartnerAccountsAvailsList_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_579863.validator(path, query, header, formData, body)
  let scheme = call_579863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579863.url(scheme.get, call_579863.host, call_579863.base,
                         call_579863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579863, url, valid)

proc call*(call_579934: Call_PlaymoviespartnerAccountsAvailsList_579677;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; studioNames: JsonNode = nil;
          alt: string = "json"; pp: bool = true; videoIds: JsonNode = nil;
          pphNames: JsonNode = nil; altIds: JsonNode = nil; oauthToken: string = "";
          uploadType: string = ""; accessToken: string = ""; callback: string = "";
          altId: string = ""; key: string = ""; title: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; territories: JsonNode = nil;
          bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsAvailsList
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Avails that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   altIds: JArray
  ##         : Filter Avails that match (case-insensitive) any of the given partner-specific custom ids.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   altId: string
  ##        : Filter Avails that match a case-insensitive, partner-specific custom id.
  ## NOTE: this field is deprecated and will be removed on V2; `alt_ids`
  ## should be used instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   title: string
  ##        : Filter that matches Avails with a `title_internal_alias`,
  ## `series_title_internal_alias`, `season_title_internal_alias`,
  ## or `episode_title_internal_alias` that contains the given
  ## case-insensitive title.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   territories: JArray
  ##              : Filter Avails that match (case-insensitive) any of the given country codes,
  ## using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579935 = newJObject()
  var query_579937 = newJObject()
  add(query_579937, "upload_protocol", newJString(uploadProtocol))
  add(query_579937, "fields", newJString(fields))
  add(query_579937, "pageToken", newJString(pageToken))
  add(query_579937, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_579937.add "studioNames", studioNames
  add(query_579937, "alt", newJString(alt))
  add(query_579937, "pp", newJBool(pp))
  if videoIds != nil:
    query_579937.add "videoIds", videoIds
  if pphNames != nil:
    query_579937.add "pphNames", pphNames
  if altIds != nil:
    query_579937.add "altIds", altIds
  add(query_579937, "oauth_token", newJString(oauthToken))
  add(query_579937, "uploadType", newJString(uploadType))
  add(query_579937, "access_token", newJString(accessToken))
  add(query_579937, "callback", newJString(callback))
  add(path_579935, "accountId", newJString(accountId))
  add(query_579937, "altId", newJString(altId))
  add(query_579937, "key", newJString(key))
  add(query_579937, "title", newJString(title))
  add(query_579937, "$.xgafv", newJString(Xgafv))
  add(query_579937, "pageSize", newJInt(pageSize))
  add(query_579937, "prettyPrint", newJBool(prettyPrint))
  if territories != nil:
    query_579937.add "territories", territories
  add(query_579937, "bearer_token", newJString(bearerToken))
  result = call_579934.call(path_579935, query_579937, nil, nil, nil)

var playmoviespartnerAccountsAvailsList* = Call_PlaymoviespartnerAccountsAvailsList_579677(
    name: "playmoviespartnerAccountsAvailsList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails",
    validator: validate_PlaymoviespartnerAccountsAvailsList_579678, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsList_579679, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsAvailsGet_579976 = ref object of OpenApiRestCall_579408
proc url_PlaymoviespartnerAccountsAvailsGet_579978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "availId" in path, "`availId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/avails/"),
               (kind: VariableSegment, value: "availId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsAvailsGet_579977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Avail given its avail group id and avail id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   availId: JString (required)
  ##          : REQUIRED. Avail ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579979 = path.getOrDefault("accountId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "accountId", valid_579979
  var valid_579980 = path.getOrDefault("availId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "availId", valid_579980
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579981 = query.getOrDefault("upload_protocol")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "upload_protocol", valid_579981
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("pp")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "pp", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("uploadType")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "uploadType", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("callback")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "callback", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  var valid_579993 = query.getOrDefault("bearer_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "bearer_token", valid_579993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579994: Call_PlaymoviespartnerAccountsAvailsGet_579976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Avail given its avail group id and avail id.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_PlaymoviespartnerAccountsAvailsGet_579976;
          accountId: string; availId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsAvailsGet
  ## Get an Avail given its avail group id and avail id.
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   availId: string (required)
  ##          : REQUIRED. Avail ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  add(query_579997, "upload_protocol", newJString(uploadProtocol))
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "pp", newJBool(pp))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "uploadType", newJString(uploadType))
  add(query_579997, "access_token", newJString(accessToken))
  add(query_579997, "callback", newJString(callback))
  add(path_579996, "accountId", newJString(accountId))
  add(path_579996, "availId", newJString(availId))
  add(query_579997, "key", newJString(key))
  add(query_579997, "$.xgafv", newJString(Xgafv))
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  add(query_579997, "bearer_token", newJString(bearerToken))
  result = call_579995.call(path_579996, query_579997, nil, nil, nil)

var playmoviespartnerAccountsAvailsGet* = Call_PlaymoviespartnerAccountsAvailsGet_579976(
    name: "playmoviespartnerAccountsAvailsGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails/{availId}",
    validator: validate_PlaymoviespartnerAccountsAvailsGet_579977, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsGet_579978, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersList_579998 = ref object of OpenApiRestCall_579408
proc url_PlaymoviespartnerAccountsOrdersList_580000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/orders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsOrdersList_579999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580001 = path.getOrDefault("accountId")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "accountId", valid_580001
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Orders that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Filter that matches Orders with a `name`, `show`, `season` or `episode`
  ## that contains the given case-insensitive name.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   customId: JString
  ##           : Filter Orders that match a case-insensitive, partner-specific custom id.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   status: JArray
  ##         : Filter Orders that match one of the given status.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580002 = query.getOrDefault("upload_protocol")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "upload_protocol", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  var valid_580004 = query.getOrDefault("pageToken")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "pageToken", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("studioNames")
  valid_580006 = validateParameter(valid_580006, JArray, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "studioNames", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("pp")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "pp", valid_580008
  var valid_580009 = query.getOrDefault("videoIds")
  valid_580009 = validateParameter(valid_580009, JArray, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "videoIds", valid_580009
  var valid_580010 = query.getOrDefault("pphNames")
  valid_580010 = validateParameter(valid_580010, JArray, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "pphNames", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("access_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "access_token", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("name")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "name", valid_580016
  var valid_580017 = query.getOrDefault("$.xgafv")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("1"))
  if valid_580017 != nil:
    section.add "$.xgafv", valid_580017
  var valid_580018 = query.getOrDefault("customId")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "customId", valid_580018
  var valid_580019 = query.getOrDefault("pageSize")
  valid_580019 = validateParameter(valid_580019, JInt, required = false, default = nil)
  if valid_580019 != nil:
    section.add "pageSize", valid_580019
  var valid_580020 = query.getOrDefault("status")
  valid_580020 = validateParameter(valid_580020, JArray, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "status", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  var valid_580022 = query.getOrDefault("bearer_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "bearer_token", valid_580022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_PlaymoviespartnerAccountsOrdersList_579998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_PlaymoviespartnerAccountsOrdersList_579998;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; studioNames: JsonNode = nil;
          alt: string = "json"; pp: bool = true; videoIds: JsonNode = nil;
          pphNames: JsonNode = nil; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; customId: string = ""; pageSize: int = 0;
          status: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsOrdersList
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Orders that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Filter that matches Orders with a `name`, `show`, `season` or `episode`
  ## that contains the given case-insensitive name.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   customId: string
  ##           : Filter Orders that match a case-insensitive, partner-specific custom id.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   status: JArray
  ##         : Filter Orders that match one of the given status.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "pageToken", newJString(pageToken))
  add(query_580026, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_580026.add "studioNames", studioNames
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "pp", newJBool(pp))
  if videoIds != nil:
    query_580026.add "videoIds", videoIds
  if pphNames != nil:
    query_580026.add "pphNames", pphNames
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "callback", newJString(callback))
  add(path_580025, "accountId", newJString(accountId))
  add(query_580026, "key", newJString(key))
  add(query_580026, "name", newJString(name))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  add(query_580026, "customId", newJString(customId))
  add(query_580026, "pageSize", newJInt(pageSize))
  if status != nil:
    query_580026.add "status", status
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  add(query_580026, "bearer_token", newJString(bearerToken))
  result = call_580024.call(path_580025, query_580026, nil, nil, nil)

var playmoviespartnerAccountsOrdersList* = Call_PlaymoviespartnerAccountsOrdersList_579998(
    name: "playmoviespartnerAccountsOrdersList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders",
    validator: validate_PlaymoviespartnerAccountsOrdersList_579999, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersList_580000, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersGet_580027 = ref object of OpenApiRestCall_579408
proc url_PlaymoviespartnerAccountsOrdersGet_580029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsOrdersGet_580028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   orderId: JString (required)
  ##          : REQUIRED. Order ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580030 = path.getOrDefault("accountId")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "accountId", valid_580030
  var valid_580031 = path.getOrDefault("orderId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "orderId", valid_580031
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
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
  var valid_580038 = query.getOrDefault("uploadType")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "uploadType", valid_580038
  var valid_580039 = query.getOrDefault("access_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "access_token", valid_580039
  var valid_580040 = query.getOrDefault("callback")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "callback", valid_580040
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
  if body != nil:
    result.add "body", body

proc call*(call_580045: Call_PlaymoviespartnerAccountsOrdersGet_580027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_PlaymoviespartnerAccountsOrdersGet_580027;
          accountId: string; orderId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsOrdersGet
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   orderId: string (required)
  ##          : REQUIRED. Order ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  add(query_580048, "upload_protocol", newJString(uploadProtocol))
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "pp", newJBool(pp))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "uploadType", newJString(uploadType))
  add(query_580048, "access_token", newJString(accessToken))
  add(query_580048, "callback", newJString(callback))
  add(path_580047, "accountId", newJString(accountId))
  add(path_580047, "orderId", newJString(orderId))
  add(query_580048, "key", newJString(key))
  add(query_580048, "$.xgafv", newJString(Xgafv))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  add(query_580048, "bearer_token", newJString(bearerToken))
  result = call_580046.call(path_580047, query_580048, nil, nil, nil)

var playmoviespartnerAccountsOrdersGet* = Call_PlaymoviespartnerAccountsOrdersGet_580027(
    name: "playmoviespartnerAccountsOrdersGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders/{orderId}",
    validator: validate_PlaymoviespartnerAccountsOrdersGet_580028, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersGet_580029, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosList_580049 = ref object of OpenApiRestCall_579408
proc url_PlaymoviespartnerAccountsStoreInfosList_580051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/storeInfos")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsStoreInfosList_580050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580052 = path.getOrDefault("accountId")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "accountId", valid_580052
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter StoreInfos that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   seasonIds: JArray
  ##            : Filter StoreInfos that match any of the given `season_id`s.
  ##   mids: JArray
  ##       : Filter StoreInfos that match any of the given `mid`s.
  ##   videoId: JString
  ##          : Filter StoreInfos that match a given `video_id`.
  ## NOTE: this field is deprecated and will be removed on V2; `video_ids`
  ## should be used instead.
  ##   countries: JArray
  ##            : Filter StoreInfos that match (case-insensitive) any of the given country
  ## codes, using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Filter that matches StoreInfos with a `name` or `show_name`
  ## that contains the given case-insensitive name.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
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
  var valid_580055 = query.getOrDefault("pageToken")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "pageToken", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("studioNames")
  valid_580057 = validateParameter(valid_580057, JArray, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "studioNames", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("pp")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "pp", valid_580059
  var valid_580060 = query.getOrDefault("videoIds")
  valid_580060 = validateParameter(valid_580060, JArray, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "videoIds", valid_580060
  var valid_580061 = query.getOrDefault("pphNames")
  valid_580061 = validateParameter(valid_580061, JArray, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "pphNames", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("uploadType")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "uploadType", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("callback")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "callback", valid_580065
  var valid_580066 = query.getOrDefault("seasonIds")
  valid_580066 = validateParameter(valid_580066, JArray, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "seasonIds", valid_580066
  var valid_580067 = query.getOrDefault("mids")
  valid_580067 = validateParameter(valid_580067, JArray, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "mids", valid_580067
  var valid_580068 = query.getOrDefault("videoId")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "videoId", valid_580068
  var valid_580069 = query.getOrDefault("countries")
  valid_580069 = validateParameter(valid_580069, JArray, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "countries", valid_580069
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("name")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "name", valid_580071
  var valid_580072 = query.getOrDefault("$.xgafv")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("1"))
  if valid_580072 != nil:
    section.add "$.xgafv", valid_580072
  var valid_580073 = query.getOrDefault("pageSize")
  valid_580073 = validateParameter(valid_580073, JInt, required = false, default = nil)
  if valid_580073 != nil:
    section.add "pageSize", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  var valid_580075 = query.getOrDefault("bearer_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "bearer_token", valid_580075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580076: Call_PlaymoviespartnerAccountsStoreInfosList_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_PlaymoviespartnerAccountsStoreInfosList_580049;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; studioNames: JsonNode = nil;
          alt: string = "json"; pp: bool = true; videoIds: JsonNode = nil;
          pphNames: JsonNode = nil; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; seasonIds: JsonNode = nil;
          mids: JsonNode = nil; videoId: string = ""; countries: JsonNode = nil;
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsStoreInfosList
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter StoreInfos that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   seasonIds: JArray
  ##            : Filter StoreInfos that match any of the given `season_id`s.
  ##   mids: JArray
  ##       : Filter StoreInfos that match any of the given `mid`s.
  ##   videoId: string
  ##          : Filter StoreInfos that match a given `video_id`.
  ## NOTE: this field is deprecated and will be removed on V2; `video_ids`
  ## should be used instead.
  ##   countries: JArray
  ##            : Filter StoreInfos that match (case-insensitive) any of the given country
  ## codes, using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Filter that matches StoreInfos with a `name` or `show_name`
  ## that contains the given case-insensitive name.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580078 = newJObject()
  var query_580079 = newJObject()
  add(query_580079, "upload_protocol", newJString(uploadProtocol))
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "pageToken", newJString(pageToken))
  add(query_580079, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_580079.add "studioNames", studioNames
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "pp", newJBool(pp))
  if videoIds != nil:
    query_580079.add "videoIds", videoIds
  if pphNames != nil:
    query_580079.add "pphNames", pphNames
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "uploadType", newJString(uploadType))
  add(query_580079, "access_token", newJString(accessToken))
  add(query_580079, "callback", newJString(callback))
  add(path_580078, "accountId", newJString(accountId))
  if seasonIds != nil:
    query_580079.add "seasonIds", seasonIds
  if mids != nil:
    query_580079.add "mids", mids
  add(query_580079, "videoId", newJString(videoId))
  if countries != nil:
    query_580079.add "countries", countries
  add(query_580079, "key", newJString(key))
  add(query_580079, "name", newJString(name))
  add(query_580079, "$.xgafv", newJString(Xgafv))
  add(query_580079, "pageSize", newJInt(pageSize))
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  add(query_580079, "bearer_token", newJString(bearerToken))
  result = call_580077.call(path_580078, query_580079, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosList* = Call_PlaymoviespartnerAccountsStoreInfosList_580049(
    name: "playmoviespartnerAccountsStoreInfosList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos",
    validator: validate_PlaymoviespartnerAccountsStoreInfosList_580050, base: "/",
    url: url_PlaymoviespartnerAccountsStoreInfosList_580051,
    schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosCountryGet_580080 = ref object of OpenApiRestCall_579408
proc url_PlaymoviespartnerAccountsStoreInfosCountryGet_580082(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "videoId" in path, "`videoId` is a required path parameter"
  assert "country" in path, "`country` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/storeInfos/"),
               (kind: VariableSegment, value: "videoId"),
               (kind: ConstantSegment, value: "/country/"),
               (kind: VariableSegment, value: "country")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsStoreInfosCountryGet_580081(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   country: JString (required)
  ##          : REQUIRED. Edit country.
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   videoId: JString (required)
  ##          : REQUIRED. Video ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `country` field"
  var valid_580083 = path.getOrDefault("country")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "country", valid_580083
  var valid_580084 = path.getOrDefault("accountId")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "accountId", valid_580084
  var valid_580085 = path.getOrDefault("videoId")
  valid_580085 = validateParameter(valid_580085, JString, required = true,
                                 default = nil)
  if valid_580085 != nil:
    section.add "videoId", valid_580085
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580086 = query.getOrDefault("upload_protocol")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "upload_protocol", valid_580086
  var valid_580087 = query.getOrDefault("fields")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "fields", valid_580087
  var valid_580088 = query.getOrDefault("quotaUser")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "quotaUser", valid_580088
  var valid_580089 = query.getOrDefault("alt")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("json"))
  if valid_580089 != nil:
    section.add "alt", valid_580089
  var valid_580090 = query.getOrDefault("pp")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "pp", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("access_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "access_token", valid_580093
  var valid_580094 = query.getOrDefault("callback")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "callback", valid_580094
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("$.xgafv")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("1"))
  if valid_580096 != nil:
    section.add "$.xgafv", valid_580096
  var valid_580097 = query.getOrDefault("prettyPrint")
  valid_580097 = validateParameter(valid_580097, JBool, required = false,
                                 default = newJBool(true))
  if valid_580097 != nil:
    section.add "prettyPrint", valid_580097
  var valid_580098 = query.getOrDefault("bearer_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "bearer_token", valid_580098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580099: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_580080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_580080;
          country: string; accountId: string; videoId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; accessToken: string = ""; callback: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsStoreInfosCountryGet
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
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
  ##   country: string (required)
  ##          : REQUIRED. Edit country.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   videoId: string (required)
  ##          : REQUIRED. Video ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580101 = newJObject()
  var query_580102 = newJObject()
  add(query_580102, "upload_protocol", newJString(uploadProtocol))
  add(query_580102, "fields", newJString(fields))
  add(query_580102, "quotaUser", newJString(quotaUser))
  add(query_580102, "alt", newJString(alt))
  add(query_580102, "pp", newJBool(pp))
  add(path_580101, "country", newJString(country))
  add(query_580102, "oauth_token", newJString(oauthToken))
  add(query_580102, "uploadType", newJString(uploadType))
  add(query_580102, "access_token", newJString(accessToken))
  add(query_580102, "callback", newJString(callback))
  add(path_580101, "accountId", newJString(accountId))
  add(query_580102, "key", newJString(key))
  add(query_580102, "$.xgafv", newJString(Xgafv))
  add(path_580101, "videoId", newJString(videoId))
  add(query_580102, "prettyPrint", newJBool(prettyPrint))
  add(query_580102, "bearer_token", newJString(bearerToken))
  result = call_580100.call(path_580101, query_580102, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosCountryGet* = Call_PlaymoviespartnerAccountsStoreInfosCountryGet_580080(
    name: "playmoviespartnerAccountsStoreInfosCountryGet",
    meth: HttpMethod.HttpGet, host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos/{videoId}/country/{country}",
    validator: validate_PlaymoviespartnerAccountsStoreInfosCountryGet_580081,
    base: "/", url: url_PlaymoviespartnerAccountsStoreInfosCountryGet_580082,
    schemes: {Scheme.Https})
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
