
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlaymoviespartnerAccountsAvailsList_593677 = ref object of OpenApiRestCall_593408
proc url_PlaymoviespartnerAccountsAvailsList_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlaymoviespartnerAccountsAvailsList_593678(path: JsonNode;
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
  var valid_593805 = path.getOrDefault("accountId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "accountId", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("pageToken")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "pageToken", valid_593808
  var valid_593809 = query.getOrDefault("quotaUser")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "quotaUser", valid_593809
  var valid_593810 = query.getOrDefault("studioNames")
  valid_593810 = validateParameter(valid_593810, JArray, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "studioNames", valid_593810
  var valid_593824 = query.getOrDefault("alt")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = newJString("json"))
  if valid_593824 != nil:
    section.add "alt", valid_593824
  var valid_593825 = query.getOrDefault("pp")
  valid_593825 = validateParameter(valid_593825, JBool, required = false,
                                 default = newJBool(true))
  if valid_593825 != nil:
    section.add "pp", valid_593825
  var valid_593826 = query.getOrDefault("videoIds")
  valid_593826 = validateParameter(valid_593826, JArray, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "videoIds", valid_593826
  var valid_593827 = query.getOrDefault("pphNames")
  valid_593827 = validateParameter(valid_593827, JArray, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "pphNames", valid_593827
  var valid_593828 = query.getOrDefault("altIds")
  valid_593828 = validateParameter(valid_593828, JArray, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "altIds", valid_593828
  var valid_593829 = query.getOrDefault("oauth_token")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = nil)
  if valid_593829 != nil:
    section.add "oauth_token", valid_593829
  var valid_593830 = query.getOrDefault("uploadType")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = nil)
  if valid_593830 != nil:
    section.add "uploadType", valid_593830
  var valid_593831 = query.getOrDefault("access_token")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = nil)
  if valid_593831 != nil:
    section.add "access_token", valid_593831
  var valid_593832 = query.getOrDefault("callback")
  valid_593832 = validateParameter(valid_593832, JString, required = false,
                                 default = nil)
  if valid_593832 != nil:
    section.add "callback", valid_593832
  var valid_593833 = query.getOrDefault("altId")
  valid_593833 = validateParameter(valid_593833, JString, required = false,
                                 default = nil)
  if valid_593833 != nil:
    section.add "altId", valid_593833
  var valid_593834 = query.getOrDefault("key")
  valid_593834 = validateParameter(valid_593834, JString, required = false,
                                 default = nil)
  if valid_593834 != nil:
    section.add "key", valid_593834
  var valid_593835 = query.getOrDefault("title")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = nil)
  if valid_593835 != nil:
    section.add "title", valid_593835
  var valid_593836 = query.getOrDefault("$.xgafv")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = newJString("1"))
  if valid_593836 != nil:
    section.add "$.xgafv", valid_593836
  var valid_593837 = query.getOrDefault("pageSize")
  valid_593837 = validateParameter(valid_593837, JInt, required = false, default = nil)
  if valid_593837 != nil:
    section.add "pageSize", valid_593837
  var valid_593838 = query.getOrDefault("prettyPrint")
  valid_593838 = validateParameter(valid_593838, JBool, required = false,
                                 default = newJBool(true))
  if valid_593838 != nil:
    section.add "prettyPrint", valid_593838
  var valid_593839 = query.getOrDefault("territories")
  valid_593839 = validateParameter(valid_593839, JArray, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "territories", valid_593839
  var valid_593840 = query.getOrDefault("bearer_token")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "bearer_token", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_PlaymoviespartnerAccountsAvailsList_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_PlaymoviespartnerAccountsAvailsList_593677;
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
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  add(query_593937, "upload_protocol", newJString(uploadProtocol))
  add(query_593937, "fields", newJString(fields))
  add(query_593937, "pageToken", newJString(pageToken))
  add(query_593937, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_593937.add "studioNames", studioNames
  add(query_593937, "alt", newJString(alt))
  add(query_593937, "pp", newJBool(pp))
  if videoIds != nil:
    query_593937.add "videoIds", videoIds
  if pphNames != nil:
    query_593937.add "pphNames", pphNames
  if altIds != nil:
    query_593937.add "altIds", altIds
  add(query_593937, "oauth_token", newJString(oauthToken))
  add(query_593937, "uploadType", newJString(uploadType))
  add(query_593937, "access_token", newJString(accessToken))
  add(query_593937, "callback", newJString(callback))
  add(path_593935, "accountId", newJString(accountId))
  add(query_593937, "altId", newJString(altId))
  add(query_593937, "key", newJString(key))
  add(query_593937, "title", newJString(title))
  add(query_593937, "$.xgafv", newJString(Xgafv))
  add(query_593937, "pageSize", newJInt(pageSize))
  add(query_593937, "prettyPrint", newJBool(prettyPrint))
  if territories != nil:
    query_593937.add "territories", territories
  add(query_593937, "bearer_token", newJString(bearerToken))
  result = call_593934.call(path_593935, query_593937, nil, nil, nil)

var playmoviespartnerAccountsAvailsList* = Call_PlaymoviespartnerAccountsAvailsList_593677(
    name: "playmoviespartnerAccountsAvailsList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails",
    validator: validate_PlaymoviespartnerAccountsAvailsList_593678, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsList_593679, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsAvailsGet_593976 = ref object of OpenApiRestCall_593408
proc url_PlaymoviespartnerAccountsAvailsGet_593978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlaymoviespartnerAccountsAvailsGet_593977(path: JsonNode;
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
  var valid_593979 = path.getOrDefault("accountId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "accountId", valid_593979
  var valid_593980 = path.getOrDefault("availId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "availId", valid_593980
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
  var valid_593981 = query.getOrDefault("upload_protocol")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "upload_protocol", valid_593981
  var valid_593982 = query.getOrDefault("fields")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "fields", valid_593982
  var valid_593983 = query.getOrDefault("quotaUser")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "quotaUser", valid_593983
  var valid_593984 = query.getOrDefault("alt")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("json"))
  if valid_593984 != nil:
    section.add "alt", valid_593984
  var valid_593985 = query.getOrDefault("pp")
  valid_593985 = validateParameter(valid_593985, JBool, required = false,
                                 default = newJBool(true))
  if valid_593985 != nil:
    section.add "pp", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("uploadType")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "uploadType", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("callback")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "callback", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  var valid_593993 = query.getOrDefault("bearer_token")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "bearer_token", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_PlaymoviespartnerAccountsAvailsGet_593976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Avail given its avail group id and avail id.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_PlaymoviespartnerAccountsAvailsGet_593976;
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
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(query_593997, "upload_protocol", newJString(uploadProtocol))
  add(query_593997, "fields", newJString(fields))
  add(query_593997, "quotaUser", newJString(quotaUser))
  add(query_593997, "alt", newJString(alt))
  add(query_593997, "pp", newJBool(pp))
  add(query_593997, "oauth_token", newJString(oauthToken))
  add(query_593997, "uploadType", newJString(uploadType))
  add(query_593997, "access_token", newJString(accessToken))
  add(query_593997, "callback", newJString(callback))
  add(path_593996, "accountId", newJString(accountId))
  add(path_593996, "availId", newJString(availId))
  add(query_593997, "key", newJString(key))
  add(query_593997, "$.xgafv", newJString(Xgafv))
  add(query_593997, "prettyPrint", newJBool(prettyPrint))
  add(query_593997, "bearer_token", newJString(bearerToken))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var playmoviespartnerAccountsAvailsGet* = Call_PlaymoviespartnerAccountsAvailsGet_593976(
    name: "playmoviespartnerAccountsAvailsGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails/{availId}",
    validator: validate_PlaymoviespartnerAccountsAvailsGet_593977, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsGet_593978, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersList_593998 = ref object of OpenApiRestCall_593408
proc url_PlaymoviespartnerAccountsOrdersList_594000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlaymoviespartnerAccountsOrdersList_593999(path: JsonNode;
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
  var valid_594001 = path.getOrDefault("accountId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "accountId", valid_594001
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
  var valid_594002 = query.getOrDefault("upload_protocol")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "upload_protocol", valid_594002
  var valid_594003 = query.getOrDefault("fields")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "fields", valid_594003
  var valid_594004 = query.getOrDefault("pageToken")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "pageToken", valid_594004
  var valid_594005 = query.getOrDefault("quotaUser")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "quotaUser", valid_594005
  var valid_594006 = query.getOrDefault("studioNames")
  valid_594006 = validateParameter(valid_594006, JArray, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "studioNames", valid_594006
  var valid_594007 = query.getOrDefault("alt")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = newJString("json"))
  if valid_594007 != nil:
    section.add "alt", valid_594007
  var valid_594008 = query.getOrDefault("pp")
  valid_594008 = validateParameter(valid_594008, JBool, required = false,
                                 default = newJBool(true))
  if valid_594008 != nil:
    section.add "pp", valid_594008
  var valid_594009 = query.getOrDefault("videoIds")
  valid_594009 = validateParameter(valid_594009, JArray, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "videoIds", valid_594009
  var valid_594010 = query.getOrDefault("pphNames")
  valid_594010 = validateParameter(valid_594010, JArray, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "pphNames", valid_594010
  var valid_594011 = query.getOrDefault("oauth_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "oauth_token", valid_594011
  var valid_594012 = query.getOrDefault("uploadType")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "uploadType", valid_594012
  var valid_594013 = query.getOrDefault("access_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "access_token", valid_594013
  var valid_594014 = query.getOrDefault("callback")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "callback", valid_594014
  var valid_594015 = query.getOrDefault("key")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "key", valid_594015
  var valid_594016 = query.getOrDefault("name")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "name", valid_594016
  var valid_594017 = query.getOrDefault("$.xgafv")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = newJString("1"))
  if valid_594017 != nil:
    section.add "$.xgafv", valid_594017
  var valid_594018 = query.getOrDefault("customId")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "customId", valid_594018
  var valid_594019 = query.getOrDefault("pageSize")
  valid_594019 = validateParameter(valid_594019, JInt, required = false, default = nil)
  if valid_594019 != nil:
    section.add "pageSize", valid_594019
  var valid_594020 = query.getOrDefault("status")
  valid_594020 = validateParameter(valid_594020, JArray, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "status", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
  var valid_594022 = query.getOrDefault("bearer_token")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "bearer_token", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_PlaymoviespartnerAccountsOrdersList_593998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_PlaymoviespartnerAccountsOrdersList_593998;
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
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "pageToken", newJString(pageToken))
  add(query_594026, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_594026.add "studioNames", studioNames
  add(query_594026, "alt", newJString(alt))
  add(query_594026, "pp", newJBool(pp))
  if videoIds != nil:
    query_594026.add "videoIds", videoIds
  if pphNames != nil:
    query_594026.add "pphNames", pphNames
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "callback", newJString(callback))
  add(path_594025, "accountId", newJString(accountId))
  add(query_594026, "key", newJString(key))
  add(query_594026, "name", newJString(name))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  add(query_594026, "customId", newJString(customId))
  add(query_594026, "pageSize", newJInt(pageSize))
  if status != nil:
    query_594026.add "status", status
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  add(query_594026, "bearer_token", newJString(bearerToken))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var playmoviespartnerAccountsOrdersList* = Call_PlaymoviespartnerAccountsOrdersList_593998(
    name: "playmoviespartnerAccountsOrdersList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders",
    validator: validate_PlaymoviespartnerAccountsOrdersList_593999, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersList_594000, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersGet_594027 = ref object of OpenApiRestCall_593408
proc url_PlaymoviespartnerAccountsOrdersGet_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlaymoviespartnerAccountsOrdersGet_594028(path: JsonNode;
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
  var valid_594030 = path.getOrDefault("accountId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "accountId", valid_594030
  var valid_594031 = path.getOrDefault("orderId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "orderId", valid_594031
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
  var valid_594032 = query.getOrDefault("upload_protocol")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "upload_protocol", valid_594032
  var valid_594033 = query.getOrDefault("fields")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "fields", valid_594033
  var valid_594034 = query.getOrDefault("quotaUser")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "quotaUser", valid_594034
  var valid_594035 = query.getOrDefault("alt")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("json"))
  if valid_594035 != nil:
    section.add "alt", valid_594035
  var valid_594036 = query.getOrDefault("pp")
  valid_594036 = validateParameter(valid_594036, JBool, required = false,
                                 default = newJBool(true))
  if valid_594036 != nil:
    section.add "pp", valid_594036
  var valid_594037 = query.getOrDefault("oauth_token")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "oauth_token", valid_594037
  var valid_594038 = query.getOrDefault("uploadType")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "uploadType", valid_594038
  var valid_594039 = query.getOrDefault("access_token")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "access_token", valid_594039
  var valid_594040 = query.getOrDefault("callback")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "callback", valid_594040
  var valid_594041 = query.getOrDefault("key")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "key", valid_594041
  var valid_594042 = query.getOrDefault("$.xgafv")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("1"))
  if valid_594042 != nil:
    section.add "$.xgafv", valid_594042
  var valid_594043 = query.getOrDefault("prettyPrint")
  valid_594043 = validateParameter(valid_594043, JBool, required = false,
                                 default = newJBool(true))
  if valid_594043 != nil:
    section.add "prettyPrint", valid_594043
  var valid_594044 = query.getOrDefault("bearer_token")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "bearer_token", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_PlaymoviespartnerAccountsOrdersGet_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_PlaymoviespartnerAccountsOrdersGet_594027;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "upload_protocol", newJString(uploadProtocol))
  add(query_594048, "fields", newJString(fields))
  add(query_594048, "quotaUser", newJString(quotaUser))
  add(query_594048, "alt", newJString(alt))
  add(query_594048, "pp", newJBool(pp))
  add(query_594048, "oauth_token", newJString(oauthToken))
  add(query_594048, "uploadType", newJString(uploadType))
  add(query_594048, "access_token", newJString(accessToken))
  add(query_594048, "callback", newJString(callback))
  add(path_594047, "accountId", newJString(accountId))
  add(path_594047, "orderId", newJString(orderId))
  add(query_594048, "key", newJString(key))
  add(query_594048, "$.xgafv", newJString(Xgafv))
  add(query_594048, "prettyPrint", newJBool(prettyPrint))
  add(query_594048, "bearer_token", newJString(bearerToken))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var playmoviespartnerAccountsOrdersGet* = Call_PlaymoviespartnerAccountsOrdersGet_594027(
    name: "playmoviespartnerAccountsOrdersGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders/{orderId}",
    validator: validate_PlaymoviespartnerAccountsOrdersGet_594028, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersGet_594029, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosList_594049 = ref object of OpenApiRestCall_593408
proc url_PlaymoviespartnerAccountsStoreInfosList_594051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlaymoviespartnerAccountsStoreInfosList_594050(path: JsonNode;
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
  var valid_594052 = path.getOrDefault("accountId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "accountId", valid_594052
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
  var valid_594053 = query.getOrDefault("upload_protocol")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "upload_protocol", valid_594053
  var valid_594054 = query.getOrDefault("fields")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "fields", valid_594054
  var valid_594055 = query.getOrDefault("pageToken")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "pageToken", valid_594055
  var valid_594056 = query.getOrDefault("quotaUser")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "quotaUser", valid_594056
  var valid_594057 = query.getOrDefault("studioNames")
  valid_594057 = validateParameter(valid_594057, JArray, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "studioNames", valid_594057
  var valid_594058 = query.getOrDefault("alt")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("json"))
  if valid_594058 != nil:
    section.add "alt", valid_594058
  var valid_594059 = query.getOrDefault("pp")
  valid_594059 = validateParameter(valid_594059, JBool, required = false,
                                 default = newJBool(true))
  if valid_594059 != nil:
    section.add "pp", valid_594059
  var valid_594060 = query.getOrDefault("videoIds")
  valid_594060 = validateParameter(valid_594060, JArray, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "videoIds", valid_594060
  var valid_594061 = query.getOrDefault("pphNames")
  valid_594061 = validateParameter(valid_594061, JArray, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "pphNames", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("uploadType")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "uploadType", valid_594063
  var valid_594064 = query.getOrDefault("access_token")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "access_token", valid_594064
  var valid_594065 = query.getOrDefault("callback")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "callback", valid_594065
  var valid_594066 = query.getOrDefault("seasonIds")
  valid_594066 = validateParameter(valid_594066, JArray, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "seasonIds", valid_594066
  var valid_594067 = query.getOrDefault("mids")
  valid_594067 = validateParameter(valid_594067, JArray, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "mids", valid_594067
  var valid_594068 = query.getOrDefault("videoId")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "videoId", valid_594068
  var valid_594069 = query.getOrDefault("countries")
  valid_594069 = validateParameter(valid_594069, JArray, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "countries", valid_594069
  var valid_594070 = query.getOrDefault("key")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "key", valid_594070
  var valid_594071 = query.getOrDefault("name")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "name", valid_594071
  var valid_594072 = query.getOrDefault("$.xgafv")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("1"))
  if valid_594072 != nil:
    section.add "$.xgafv", valid_594072
  var valid_594073 = query.getOrDefault("pageSize")
  valid_594073 = validateParameter(valid_594073, JInt, required = false, default = nil)
  if valid_594073 != nil:
    section.add "pageSize", valid_594073
  var valid_594074 = query.getOrDefault("prettyPrint")
  valid_594074 = validateParameter(valid_594074, JBool, required = false,
                                 default = newJBool(true))
  if valid_594074 != nil:
    section.add "prettyPrint", valid_594074
  var valid_594075 = query.getOrDefault("bearer_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "bearer_token", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_PlaymoviespartnerAccountsStoreInfosList_594049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_PlaymoviespartnerAccountsStoreInfosList_594049;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(query_594079, "upload_protocol", newJString(uploadProtocol))
  add(query_594079, "fields", newJString(fields))
  add(query_594079, "pageToken", newJString(pageToken))
  add(query_594079, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_594079.add "studioNames", studioNames
  add(query_594079, "alt", newJString(alt))
  add(query_594079, "pp", newJBool(pp))
  if videoIds != nil:
    query_594079.add "videoIds", videoIds
  if pphNames != nil:
    query_594079.add "pphNames", pphNames
  add(query_594079, "oauth_token", newJString(oauthToken))
  add(query_594079, "uploadType", newJString(uploadType))
  add(query_594079, "access_token", newJString(accessToken))
  add(query_594079, "callback", newJString(callback))
  add(path_594078, "accountId", newJString(accountId))
  if seasonIds != nil:
    query_594079.add "seasonIds", seasonIds
  if mids != nil:
    query_594079.add "mids", mids
  add(query_594079, "videoId", newJString(videoId))
  if countries != nil:
    query_594079.add "countries", countries
  add(query_594079, "key", newJString(key))
  add(query_594079, "name", newJString(name))
  add(query_594079, "$.xgafv", newJString(Xgafv))
  add(query_594079, "pageSize", newJInt(pageSize))
  add(query_594079, "prettyPrint", newJBool(prettyPrint))
  add(query_594079, "bearer_token", newJString(bearerToken))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosList* = Call_PlaymoviespartnerAccountsStoreInfosList_594049(
    name: "playmoviespartnerAccountsStoreInfosList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos",
    validator: validate_PlaymoviespartnerAccountsStoreInfosList_594050, base: "/",
    url: url_PlaymoviespartnerAccountsStoreInfosList_594051,
    schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosCountryGet_594080 = ref object of OpenApiRestCall_593408
proc url_PlaymoviespartnerAccountsStoreInfosCountryGet_594082(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlaymoviespartnerAccountsStoreInfosCountryGet_594081(
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
  var valid_594083 = path.getOrDefault("country")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "country", valid_594083
  var valid_594084 = path.getOrDefault("accountId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "accountId", valid_594084
  var valid_594085 = path.getOrDefault("videoId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "videoId", valid_594085
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
  var valid_594086 = query.getOrDefault("upload_protocol")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "upload_protocol", valid_594086
  var valid_594087 = query.getOrDefault("fields")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "fields", valid_594087
  var valid_594088 = query.getOrDefault("quotaUser")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "quotaUser", valid_594088
  var valid_594089 = query.getOrDefault("alt")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = newJString("json"))
  if valid_594089 != nil:
    section.add "alt", valid_594089
  var valid_594090 = query.getOrDefault("pp")
  valid_594090 = validateParameter(valid_594090, JBool, required = false,
                                 default = newJBool(true))
  if valid_594090 != nil:
    section.add "pp", valid_594090
  var valid_594091 = query.getOrDefault("oauth_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "oauth_token", valid_594091
  var valid_594092 = query.getOrDefault("uploadType")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "uploadType", valid_594092
  var valid_594093 = query.getOrDefault("access_token")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "access_token", valid_594093
  var valid_594094 = query.getOrDefault("callback")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "callback", valid_594094
  var valid_594095 = query.getOrDefault("key")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "key", valid_594095
  var valid_594096 = query.getOrDefault("$.xgafv")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("1"))
  if valid_594096 != nil:
    section.add "$.xgafv", valid_594096
  var valid_594097 = query.getOrDefault("prettyPrint")
  valid_594097 = validateParameter(valid_594097, JBool, required = false,
                                 default = newJBool(true))
  if valid_594097 != nil:
    section.add "prettyPrint", valid_594097
  var valid_594098 = query.getOrDefault("bearer_token")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "bearer_token", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_594080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_594080;
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
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(query_594102, "upload_protocol", newJString(uploadProtocol))
  add(query_594102, "fields", newJString(fields))
  add(query_594102, "quotaUser", newJString(quotaUser))
  add(query_594102, "alt", newJString(alt))
  add(query_594102, "pp", newJBool(pp))
  add(path_594101, "country", newJString(country))
  add(query_594102, "oauth_token", newJString(oauthToken))
  add(query_594102, "uploadType", newJString(uploadType))
  add(query_594102, "access_token", newJString(accessToken))
  add(query_594102, "callback", newJString(callback))
  add(path_594101, "accountId", newJString(accountId))
  add(query_594102, "key", newJString(key))
  add(query_594102, "$.xgafv", newJString(Xgafv))
  add(path_594101, "videoId", newJString(videoId))
  add(query_594102, "prettyPrint", newJBool(prettyPrint))
  add(query_594102, "bearer_token", newJString(bearerToken))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosCountryGet* = Call_PlaymoviespartnerAccountsStoreInfosCountryGet_594080(
    name: "playmoviespartnerAccountsStoreInfosCountryGet",
    meth: HttpMethod.HttpGet, host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos/{videoId}/country/{country}",
    validator: validate_PlaymoviespartnerAccountsStoreInfosCountryGet_594081,
    base: "/", url: url_PlaymoviespartnerAccountsStoreInfosCountryGet_594082,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
